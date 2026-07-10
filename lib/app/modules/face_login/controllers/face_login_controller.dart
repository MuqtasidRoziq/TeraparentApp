import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/auth/face_login_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/face_login_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../../routes/app_pages.dart';
import '../../../modules/navigation_bar/controllers/navigation_bar_controller.dart';

class FaceLoginController extends GetxController {
  CameraController? cameraController;
  Timer? _verificationTimer;

  // Variabel Logika AI
  late FaceDetector _faceDetector;
  Interpreter? _interpreter;

  // Variabel UI
  final isCameraReady = false.obs;
  final isVerifying = false.obs;
  final isMatched = false.obs;
  final hasError = false.obs;
  final statusText = 'Menyiapkan sistem...'.obs;
  final errorMessage = ''.obs;

  // Storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Inject Service
  final FaceAuthService _faceAuthService = Get.find<FaceAuthService>();

  @override
  void onInit() {
    super.onInit();
    _initAILogic();
    _initCameraLogic();
  }

  // --- LOGIKA AI (TFLITE & ML KIT) ---
  Future<void> _initAILogic() async {
    try {
      final options = FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
        performanceMode: FaceDetectorMode.fast,
      );
      _faceDetector = FaceDetector(options: options);
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobilefacenet.tflite',
      );
    } catch (e) {
      // ignore init error silently
    }
  }

  // --- LOGIKA KAMERA & TIMER ---
  Future<void> _initCameraLogic() async {
    try {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        hasError.value = true;
        errorMessage.value = 'Izin kamera ditolak.';
        return;
      }
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.jpeg
            : ImageFormatGroup.bgra8888,
      );
      await cameraController!.initialize();
      isCameraReady.value = true;
      statusText.value = 'Hadapkan wajah ke kamera';

      // Mulai Timer Real-time
      startRealtimeVerification();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Kamera error: $e';
    }
  }

  void startRealtimeVerification() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (isVerifying.value ||
          isMatched.value ||
          !isCameraReady.value ||
          _interpreter == null) {
        return;
      }
      await verifyFaceRealtime();
    });
  }

  // --- LOGIKA PROSES & API (Auto-Scan) ---
  Future<void> verifyFaceRealtime() async {
    try {
      isVerifying.value = true;
      statusText.value = 'Menganalisis bingkai...';

      final XFile photo = await cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(photo.path);

      // 2. Deteksi ML Kit
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty || faces.length > 1) {
        statusText.value = 'Wajah tidak jelas / lebih dari satu';
        isVerifying.value = false;
        return;
      }

      statusText.value = 'Mengekstrak data...';

      // 3. Proses Gambar (Crop, Resize, Normalisasi)
      final face = faces.first;
      final File imageFile = File(photo.path);
      final img.Image? originalImage = img.decodeImage(
        imageFile.readAsBytesSync(),
      );
      if (originalImage == null) throw Exception();

      final img.Image croppedFace = img.copyCrop(
        originalImage,
        x: face.boundingBox.left.toInt(),
        y: face.boundingBox.top.toInt(),
        width: face.boundingBox.width.toInt(),
        height: face.boundingBox.height.toInt(),
      );
      final img.Image resizedFace = img.copyResize(
        croppedFace,
        width: 112,
        height: 112,
      );

      var inputMatrix = List.generate(
        1,
        (i) => List.generate(
          112,
          (y) => List.generate(112, (x) => List.generate(3, (c) => 0.0)),
        ),
      );
      for (int y = 0; y < 112; y++) {
        for (int x = 0; x < 112; x++) {
          final pixel = resizedFace.getPixel(x, y);
          inputMatrix[0][y][x][0] = (pixel.r - 127.5) / 127.5;
          inputMatrix[0][y][x][1] = (pixel.g - 127.5) / 127.5;
          inputMatrix[0][y][x][2] = (pixel.b - 127.5) / 127.5;
        }
      }

      // 4. Ekstraksi TFLite
      var outputMatrix = List.generate(1, (i) => List.filled(192, 0.0));
      _interpreter!.run(inputMatrix, outputMatrix);
      List<double> faceEmbedding = outputMatrix[0];

      statusText.value = 'Mencocokkan ke database...';

      // 5. Panggil Service API
      FaceAuthRequestModel requestData = FaceAuthRequestModel(
        embedding: faceEmbedding,
      );

      final response = await _faceAuthService.loginFace(requestData);

      if (response.success && response.data != null) {
        isMatched.value = true;
        statusText.value = 'Login berhasil! Selamat datang.';

        final token = response.data!.token;
        final user = response.data!.user;
        final child = user.children.first;
        final latestResult = user.resultScreening.isNotEmpty
            ? user.resultScreening.first
            : null;

        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'user_id', value: user.id);
        await _secureStorage.write(key: 'childId', value: child.id);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email);
        await prefs.setString('full_name', user.fullName);
        await prefs.setString('phone', user.phone ?? '');
        await prefs.setString('photo_url', user.profileImage ?? '');
        await prefs.setBool('is_logged_in', true);
        await prefs.setBool('is_email_verified', user.isEmailVerified);
        await prefs.setBool(
          'is_face_recognition_active',
          user.isFaceRecognitionActive,
        );
        await prefs.setBool('has_child_data', user.hasChildData);
        await prefs.setString('childName', child.childName);
        await prefs.setString('gender', child.gender);
        await prefs.setString('birthDate', child.birthDate.toString());
        await prefs.setDouble('weightKg', child.weightKg);
        await prefs.setDouble('heightCm', child.heightCm);

        debugPrint('user id : ${user.id}');
        debugPrint('child id : ${child.id}');
        debugPrint('has child data : ${user.hasChildData}');

        if (latestResult != null) {
          await prefs.setString('mainIndication', latestResult.mainIndication);
          await prefs.setString('priorityDomain', latestResult.priorityDomain);
          await prefs.setString('riskCategory', latestResult.riskCategory);
        } else {
          await prefs.remove('mainIndication');
          await prefs.remove('priorityDomain');
          await prefs.remove('riskCategory');
        }

        await Future.delayed(const Duration(seconds: 1));

        try {
          Get.find<NavigationBarController>().reset();
        } catch (_) {}
        Get.offAllNamed(Routes.HOME);
      } else {
        statusText.value = 'Wajah tidak dikenali sistem';
      }
    } catch (e) {
      statusText.value = 'Gagal mencocokkan wajah';
    } finally {
      isVerifying.value = false;
    }
  }

  void retryCamera() {
    isMatched.value = false;
    hasError.value = false;
    _verificationTimer?.cancel();
    cameraController?.dispose();
    _initCameraLogic();
  }

  @override
  void onClose() {
    _verificationTimer?.cancel();
    cameraController?.dispose();
    _faceDetector.close();
    _interpreter?.close();
    super.onClose();
  }
}
