import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/auth/resend_otp_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/verify_otp_model.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/resend_otp_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/verify-otp_service.dart';
import 'package:teraparent_mobile/app/data/services/reset_password_service.dart';
import '../../../routes/app_pages.dart';

enum OtpPurpose { verifyEmail, resetPassword }

class VerifyOtpController extends GetxController {
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  final VerifyOtpService _verifyOtpService = Get.find<VerifyOtpService>();
  final ResendOtpService _resendOtpService = Get.find<ResendOtpService>();
  final ResetPasswordService _requestResetPasswordService = Get.find<ResetPasswordService>();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final isLoading = false.obs;
  final secondsLeft = 120.obs;
  final email = ''.obs;

  final purpose = OtpPurpose.verifyEmail.obs;

  String? _nextRoute;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadOtpSession();
  }

  Future<void> loadOtpSession() async {
    final args = Get.arguments;

    if (args != null && args is Map) {
      if (args['email'] != null) {
        email.value = args['email'].toString();
      }

      if (args['purpose'] == 'RESET_PASSWORD' ||
          args['purpose'] == 'change_password') {
        purpose.value = OtpPurpose.resetPassword;
      }

      if (args['nextRoute'] != null) {
        _nextRoute = args['nextRoute'].toString();
      }
    }

    if (email.value.isEmpty) {
      final savedEmail = await _storage.read(key: 'pending_otp_email');

      if (savedEmail != null && savedEmail.isNotEmpty) {
        email.value = savedEmail;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final pendingEmail = prefs.getString('pending_otp_email');

    if (email.value.isEmpty && pendingEmail != null && pendingEmail.isNotEmpty) {
      email.value = pendingEmail;
    }

    final expiredAt = prefs.getInt('pending_otp_expired_at');

    if (expiredAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final remaining = ((expiredAt - now) / 1000).ceil();

      secondsLeft.value = remaining > 0 ? remaining : 0;
    } else {
      secondsLeft.value = 120;
    }

    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String getOtpCode() {
    return otpControllers.map((controller) => controller.text.trim()).join();
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (focusNodes.isNotEmpty) {
      focusNodes.first.requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final otp = getOtpCode();

    if (email.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak ditemukan. Silakan ulangi proses dari awal.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (otp.length < 6) {
      Get.snackbar(
        'Error',
        'Masukkan 6 digit kode OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (purpose.value == OtpPurpose.resetPassword) {
      isLoading.value = true;

      Get.toNamed(
        _nextRoute ?? Routes.RESET_PASSWORD,
        arguments: {
          'otp': otp,
          'email': email.value,
        },
      );
      return;
    }

    try {
      isLoading.value = true;

      final request = VerifyOtpRequestModel(
        email: email.value,
        otp: otp,
      );

      final result = await _verifyOtpService.verifyOtp(
        request: request,
      );

      if (result.success) {
        final _prefs = await SharedPreferences.getInstance();
        final token = result.data!.token;
        final user = result.data!.user;

        Get.snackbar(
          'Berhasil',
          result.message.isNotEmpty
              ? result.message
              : 'Verifikasi OTP berhasil',
          snackPosition: SnackPosition.BOTTOM,
        );

        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'user_id', value: user.id);
        await _prefs.setString('email', user.email);
        await _prefs.setString('full_name', user.fullName);
        await _prefs.setString('phone', user.phone ?? '');
        await _prefs.setString("photo_url", user.profileImage ?? '');
        await _prefs.setBool('is_logged_in', true);
        await _prefs.setBool('is_email_verified', user.isEmailVerified);
        await _prefs.setBool('is_face_recognition_active', user.isFaceRecognitionActive);
        await _prefs.setBool('has_child_data', user.hasChildData);
        await _prefs.remove('pending_otp');
        await _prefs.remove('pending_otp_email');
        await _prefs.remove('pending_otp_expired_at');

        Get.offAllNamed(Routes.VERIFY_SUCCESS);
      } else {
        Get.snackbar(
          'Gagal',
          result.message.isNotEmpty
              ? result.message
              : 'Kode OTP salah atau sudah kedaluwarsa',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  void resendOtp() async {
    try {
      if (purpose.value == OtpPurpose.resetPassword) {
        final result = await _requestResetPasswordService.requestReset(
          request: RequestResetPasswordModel(email: email.value),
        );

        _applyResendCooldown(result.success, result.message);
        return;
      }
      
      final resend = ResendOtpRequestModel(email: email.value);

      final result = await _resendOtpService.resendOtp(request: resend);

      _applyResendCooldown(result.success, result.message);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error saat resend OTP: $e');
    }
  }

  Future<void> _applyResendCooldown(bool success, String message) async {
    if (success) {
      final prefs = await SharedPreferences.getInstance();

      final expiredAt = DateTime.now()
          .add(const Duration(seconds: 120))
          .millisecondsSinceEpoch;

      await prefs.setBool('pending_otp', true);
      await prefs.setString('pending_otp_email', email.value);
      await prefs.setInt('pending_otp_expired_at', expiredAt);

      secondsLeft.value = 120;
      startTimer();

      Get.snackbar(
        'Berhasil',
        message.isNotEmpty ? message : 'Kode OTP baru telah dikirim ke email Anda',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Gagal',
        message.isNotEmpty ? message : 'Gagal mengirim ulang kode OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.onClose();
  }
}