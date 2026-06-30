import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  /// ===========================
  /// TextEditingController
  /// ===========================
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  /// ===========================
  /// Observable
  /// ===========================
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  final isLoading = false.obs;

  final passwordStrength = 0.0.obs;

  final hasMinLength = false.obs;
  final hasUppercase = false.obs;
  final hasNumber = false.obs;
  final hasSpecialCharacter = false.obs;

  @override
  void onInit() {
    super.onInit();

    passwordC.addListener(checkPasswordStrength);
  }

  /// ===========================
  /// Show Hide Password
  /// ===========================

  void togglePassword() {
    hidePassword.toggle();
  }

  void toggleConfirmPassword() {
    hideConfirmPassword.toggle();
  }

  /// ===========================
  /// Password Validation
  /// ===========================

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

  /// ===========================
  /// Reset Password
  /// ===========================

  Future<void> resetPassword() async {
    String password = passwordC.text.trim();
    String confirmPassword = confirmPasswordC.text.trim();

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

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      "Berhasil",
      "Password berhasil diperbarui.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /// TODO:
    /// Ganti dengan route login milikmu
    ///
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}