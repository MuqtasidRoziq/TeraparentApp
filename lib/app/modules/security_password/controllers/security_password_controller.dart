import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/reset_password_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class SecurityPasswordController extends GetxController {
  final ResetPasswordService _requestResetPasswordService =
      Get.find<ResetPasswordService>();

  // Status apakah wajah sudah terdaftar (dibaca dari SharedPrefs)
  var isFaceRegistered = false.obs;

  var isBiometricEnabled = false.obs;
  var is2FAEnabled = false.obs;

  var isCheckingFaceStatus = false.obs;
  var isRequestingOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkFaceStatus();
  }

  Future<void> checkFaceStatus() async {
    isCheckingFaceStatus.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isFaceActive = prefs.getBool('is_face_recognition_active') ?? false;
      isFaceRegistered.value = isFaceActive;
    } catch (_) {
      isFaceRegistered.value = false;
    } finally {
      isCheckingFaceStatus.value = false;
    }
  }

  Future<void> goToChangePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null || email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email akun tidak ditemukan. Silakan login ulang.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isRequestingOtp.value = true;

      final result = await _requestResetPasswordService.requestReset(
        request: RequestResetPasswordModel(email: email),
      );

      if (!result.success) {
        Get.snackbar(
          'Gagal',
          result.message.isNotEmpty
              ? result.message
              : 'Gagal mengirim kode OTP ke email',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.toNamed(
        Routes.VERIFY_OTP,
        arguments: {
          'email': email,
          'purpose': 'RESET_PASSWORD',
          'nextRoute': Routes.RESET_PASSWORD,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRequestingOtp.value = false;
    }
  }

  void onBiometricToggle(bool value) {
    if (!isFaceRegistered.value) {
      goToFaceRegister();
      return;
    }

    isBiometricEnabled.value = value;
  }

  void goToFaceRegister() {
    Get.toNamed(Routes.FACE_REGISTER);
  }

  /// Dipanggil setelah kembali dari face_register agar status diperbarui
  Future<void> refreshFaceStatus() async {
    await checkFaceStatus();
  }

  /// Nonaktifkan face recognition
  Future<void> deactivateFaceRecognition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_face_recognition_active', false);
      isFaceRegistered.value = false;
      isBiometricEnabled.value = false;
      Get.snackbar(
        'Berhasil',
        'Login wajah telah dinonaktifkan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menonaktifkan login wajah.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}