import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/reset_password_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordService _resetPasswordService = Get.find<ResetPasswordService>();

  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final isLoading = false.obs;
  final passwordStrength = 0.0.obs;
  final hasMinLength = false.obs;
  final hasUppercase = false.obs;
  final hasNumber = false.obs;
  final hasSpecialCharacter = false.obs;

  String _email = '';
  String _otp = '';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    debugPrint('ResetPasswordController arguments: $args');

    if (args != null && args is Map) {
      _email = args['email']?.toString() ?? '';
      _otp = args['otp']?.toString() ?? '';
    }

    passwordC.addListener(checkPasswordStrength);
  }


  void togglePassword() {
    hidePassword.toggle();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword.toggle();
  }


  void checkPasswordStrength() {
    String password = passwordC.text;

    hasMinLength.value = password.length >= 8;
    hasUppercase.value =
        RegExp(r'[A-Z]').hasMatch(password);
    hasNumber.value =
        RegExp(r'[0-9]').hasMatch(password);
    hasSpecialCharacter.value =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);

    double strength = 0;

    if (hasMinLength.value) strength += 0.25;
    if (hasUppercase.value) strength += 0.25;
    if (hasNumber.value) strength += 0.25;
    if (hasSpecialCharacter.value) strength += 0.25;

    passwordStrength.value = strength;
  }


  Future<void> resetPassword() async {
    String password = passwordC.text.trim();
    String confirmPassword = confirmPasswordC.text.trim();

    if (_email.isEmpty || _otp.isEmpty) {
      Get.snackbar(
        "Error",
        "Sesi reset password tidak valid. Silakan ulangi dari awal.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Semua field harus diisi.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Peringatan",
        "Konfirmasi password tidak sama.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (passwordStrength.value < 1) {
      Get.snackbar(
        "Peringatan",
        "Password belum memenuhi semua syarat.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _resetPasswordService.resetPassword(
        resetPasswordModel: ResetPasswordModel(
          email: _email,
          otp: _otp,
          newPassword: password,
          confirmPassword: confirmPassword,
        ),
      );

      if (result.success) {
        Get.snackbar(
          "Berhasil",
          result.message.isNotEmpty
              ? result.message
              : "Password berhasil diperbarui.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Password berubah -> paksa login ulang dengan password baru.
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          "Gagal",
          result.message.isNotEmpty
              ? result.message
              : "Kode OTP tidak valid atau sudah kedaluwarsa.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}