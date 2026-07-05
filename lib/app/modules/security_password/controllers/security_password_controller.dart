import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/reset_password_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class SecurityPasswordController extends GetxController {
  final ResetPasswordService _requestResetPasswordService = Get.find<ResetPasswordService>();

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

    await Future.delayed(const Duration(milliseconds: 300));

    isCheckingFaceStatus.value = false;
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

}