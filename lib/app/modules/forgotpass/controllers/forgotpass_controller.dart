import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong",
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO:
      // Panggil API Forgot Password

      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        "Berhasil",
        "Kode OTP berhasil dikirim",
      );

      // contoh pindah halaman
      Get.toNamed(Routes.VERIFY_OTPPASS);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}