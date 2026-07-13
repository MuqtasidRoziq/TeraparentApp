import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/auth/face_login_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/face_login_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Step saat registrasi wajah
enum FaceRegisterStep {
  front,  // Hadap depan
  left,   // Putar ke kiri
  right,  // Putar ke kanan
}

class FaceRegisterController extends GetxController {
  CameraController? cameraController;
  Timer? _stepTimer;

  // Variabel Logika AI
  late FaceDetector _faceDetector;
  Interpreter? _interpreter;

  // Variabel UI
  final isCameraReady = false.obs;
  final isProcessing = false.obs;
  final isSuccess = false.obs;
  final hasError = false.obs;
  final statusText = 'Menyiapkan kamera...'.obs;
  final errorMessage = ''.obs;

  // Step management
  final currentStep = FaceRegisterStep.front.obs;
  final stepProgress = 0.obs; // 0=front, 1=left, 2=right, 3=done

  // Kumpulkan embedding dari beberapa sudut
  final List<List<double>> _collectedEmbeddings = [];

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
        enableClassification: true, // Aktifkan untuk deteksi sudut wajah
        performanceMode: FaceDetectorMode.accurate,
      );
      _faceDetector = FaceDetector(options: options);
      _interpreter =
          await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');
    } catch (e) {
      // ignore AI init error silently
    }
  }

  // --- LOGIKA KAMERA ---
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
          (c) => c.lensDirection == CameraLensDirection.front);
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid ? ImageFormatGroup.jpeg : ImageFormatGroup.bgra8888,
      );
      await cameraController!.initialize();
      isCameraReady.value = true;
      _startStepGuide();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Kamera error: $e';
    }
  }

  // --- PANDUAN STEP ---
  void _startStepGuide() {
    currentStep.value = FaceRegisterStep.front;
    stepProgress.value = 0;
    _collectedEmbeddings.clear();
    statusText.value = 'Hadapkan wajah ke depan kamera';
    _scheduleAutoCapture();
  }

  void _scheduleAutoCapture() {
    _stepTimer?.cancel();
    // Beri waktu 2.5 detik untuk pengguna memposisikan wajah, lalu auto-capture
    _stepTimer = Timer(const Duration(milliseconds: 2500), () async {
      if (!isProcessing.value && isCameraReady.value && _interpreter != null) {
        await _captureStepFrame();
      }
    });
  }

  // --- CAPTURE FRAME UNTUK SETIAP STEP ---
  Future<void> _captureStepFrame() async {
    if (isProcessing.value || cameraController == null) return;

    try {
      isProcessing.value = true;

      // Ambil Foto
      final XFile photo = await cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(photo.path);

      // Deteksi ML Kit
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty || faces.length > 1) {
        _showStepError('Wajah tidak terdeteksi. Coba lagi...');
        return;
      }

      // Proses Gambar
      final face = faces.first;
      final File imageFile = File(photo.path);
      final img.Image? originalImage =
          img.decodeImage(imageFile.readAsBytesSync());
      if (originalImage == null) throw Exception('Gagal decode gambar');

      final img.Image croppedFace = img.copyCrop(
        originalImage,
        x: face.boundingBox.left.toInt(),
        y: face.boundingBox.top.toInt(),
        width: face.boundingBox.width.toInt(),
        height: face.boundingBox.height.toInt(),
      );
      final img.Image resizedFace =
          img.copyResize(croppedFace, width: 112, height: 112);

      var inputMatrix = List.generate(
        1,
        (i) => List.generate(
          112,
          (y) => List.generate(
            112,
            (x) => List.generate(3, (c) => 0.0),
          ),
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

      var outputMatrix = List.generate(1, (i) => List.filled(192, 0.0));
      _interpreter!.run(inputMatrix, outputMatrix);
      final List<double> embedding = outputMatrix[0];

      // Simpan embedding step ini
      _collectedEmbeddings.add(embedding);

      // Lanjut ke step berikutnya atau selesai
      await _advanceToNextStep();
    } catch (e) {
      _showStepError('Gagal memproses wajah. Coba lagi...');
    } finally {
      isProcessing.value = false;
    }
  }

  void _showStepError(String msg) {
    statusText.value = msg;
    isProcessing.value = false;
    // Retry setelah 1.5 detik
    _stepTimer = Timer(const Duration(milliseconds: 1500), () {
      _updateStepInstruction();
      _scheduleAutoCapture();
    });
  }

  Future<void> _advanceToNextStep() async {
    switch (currentStep.value) {
      case FaceRegisterStep.front:
        currentStep.value = FaceRegisterStep.left;
        stepProgress.value = 1;
        statusText.value = 'Bagus! Sekarang putar wajah ke kiri';
        _scheduleAutoCapture();
        break;

      case FaceRegisterStep.left:
        currentStep.value = FaceRegisterStep.right;
        stepProgress.value = 2;
        statusText.value = 'Bagus! Sekarang putar wajah ke kanan';
        _scheduleAutoCapture();
        break;

      case FaceRegisterStep.right:
        stepProgress.value = 3;
        statusText.value = 'Menganalisis & menyimpan ke server...';
        await _finishRegistration();
        break;
    }
  }

  void _updateStepInstruction() {
    switch (currentStep.value) {
      case FaceRegisterStep.front:
        statusText.value = 'Hadapkan wajah ke depan kamera';
        break;
      case FaceRegisterStep.left:
        statusText.value = 'Putar wajah ke kiri';
        break;
      case FaceRegisterStep.right:
        statusText.value = 'Putar wajah ke kanan';
        break;
    }
  }

  // --- SELESAI: Kirim Rata-rata Embedding ke Server ---
  Future<void> _finishRegistration() async {
    if (_collectedEmbeddings.isEmpty) {
      _showStepError('Tidak ada data wajah. Ulangi registrasi.');
      _startStepGuide();
      return;
    }

    try {
      // Rata-rata semua embedding yang dikumpulkan
      final int embeddingSize = _collectedEmbeddings.first.length;
      final List<double> avgEmbedding = List.filled(embeddingSize, 0.0);
      for (final emb in _collectedEmbeddings) {
        for (int i = 0; i < embeddingSize; i++) {
          avgEmbedding[i] += emb[i];
        }
      }
      for (int i = 0; i < embeddingSize; i++) {
        avgEmbedding[i] /= _collectedEmbeddings.length;
      }

      final requestData = FaceAuthRequestModel(embedding: avgEmbedding);
      final response = await _faceAuthService.registerFace(requestData);

      if (response.success) {
        // Simpan status aktif ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_face_recognition_active', true);

        // Tampilkan animasi sukses
        isSuccess.value = true;
        statusText.value = 'Registrasi wajah berhasil!';

        // Tunggu animasi 2 detik lalu kembali
        await Future.delayed(const Duration(seconds: 2));
        Get.back(result: true); // result=true agar security page bisa refresh
      } else {
        statusText.value = 'Gagal menyimpan: ${response.message}';
        await Future.delayed(const Duration(seconds: 1));
        _startStepGuide();
      }
    } catch (e) {
      statusText.value = 'Terjadi kesalahan. Ulangi registrasi.';
      await Future.delayed(const Duration(seconds: 1));
      _startStepGuide();
    }
  }

  /// Restart proses registrasi dari awal
  void restartRegistration() {
    isSuccess.value = false;
    hasError.value = false;
    _startStepGuide();
  }

  /// Retry saat kamera error
  void retryCamera() {
    isSuccess.value = false;
    hasError.value = false;
    _stepTimer?.cancel();
    cameraController?.dispose();
    _initCameraLogic();
  }

  @override
  void onClose() {
    _stepTimer?.cancel();
    cameraController?.dispose();
    _faceDetector.close();
    _interpreter?.close();
    super.onClose();
  }
}