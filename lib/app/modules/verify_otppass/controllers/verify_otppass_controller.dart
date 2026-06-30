import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class VerifyOtpPassController extends GetxController {
  /// OTP Controller
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  /// Focus Node
  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  /// Loading
  final isLoading = false.obs;

  /// Timer
  final secondsLeft = 60.obs;

  Timer? _timer;

  /// Email
  final email = "".obs;

  @override
  void onInit() {
    super.onInit();

    /// Ambil email dari halaman sebelumnya
    if (Get.arguments != null) {
      email.value = Get.arguments["email"] ?? "";
    }

    startTimer();
  }

  /// ==============================
  /// Timer Countdown
  /// ==============================
  void startTimer() {
    secondsLeft.value = 60;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsLeft.value > 0) {
          secondsLeft.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  /// ==============================
  /// Verifikasi OTP
  /// ==============================
  Future<void> verifyOtp() async {
    final otp =
        otpControllers.map((e) => e.text.trim()).join();

    if (otp.length != 6) {
      Get.snackbar(
        "OTP",
        "Masukkan 6 digit OTP.",
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    isLoading.value = false;

    print("OTP : $otp");

    /// pindah ke halaman password baru
    Get.toNamed(Routes.RESET_PASSWORD);
  }

  /// ==============================
  /// Kirim Ulang OTP
  /// ==============================
  Future<void> resendOtp() async {
    if (secondsLeft.value != 0) return;

    for (var c in otpControllers) {
      c.clear();
    }

    focusNodes.first.requestFocus();

    startTimer();

    Get.snackbar(
      "OTP",
      "Kode OTP berhasil dikirim ulang.",
    );
  }

  @override
  void onClose() {
    _timer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}