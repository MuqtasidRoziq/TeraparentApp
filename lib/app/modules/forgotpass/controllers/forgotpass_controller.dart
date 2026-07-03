import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/otp_session_service.dart';
import 'package:teraparent_mobile/app/data/services/reset_password_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final ResetPasswordService _resetPasswordService = Get.find<ResetPasswordService>();
  final OtpSessionService _otpSessionService = Get.find<OtpSessionService>();

  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong",
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid",
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _resetPasswordService.requestReset(
        request: RequestResetPasswordModel(email: email),
      );

      if (!result.success) {
        Get.snackbar(
          "Gagal",
          result.message.isNotEmpty
              ? result.message
              : "Gagal mengirim kode OTP",
        );
        return;
      }

      await _otpSessionService.savePendingOtp(
        email: email,
        validSeconds: 120,
      );

      Get.snackbar(
        "Berhasil",
        result.message.isNotEmpty
            ? result.message
            : "Kode OTP berhasil dikirim",
      );

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
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
