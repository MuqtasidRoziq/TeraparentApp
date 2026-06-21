import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/register%20model.dart';
import 'package:teraparent_mobile/app/data/services/auth/register_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/otp_session_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RegisterService _registerService = Get.find<RegisterService>();
  final OtpSessionService _otpSessionService = Get.find<OtpSessionService>();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isChecked = false.obs;
  final isLoading = false.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  bool _isValidPassword(String password) {
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return password.length >= 8 && hasLetter && hasNumber;
  }


  Future<void> register() async {
    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      Get.snackbar('Error', 'Nama lengkap wajib diisi');
      return;
    }

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email wajib diisi');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Format email tidak valid');
      return;
    }

    if (!_isValidPassword(password)) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter dan harus memiliki kombinasi huruf serta angka',
      );
      return;
    }

    if (confirmPassword != password) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok');
      return;
    }

    if (!isChecked.value) {
      Get.snackbar('Error', 'Anda harus menyetujui ketentuan');
      return;
    }

    try {
      isLoading.value = true;

      final request = RegisterRequestModel(
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );

      final result = await _registerService.register(
        request: request,
      );

      if (result.success) {
        Get.snackbar(
          'Berhasil',
          result.message.isNotEmpty
              ? result.message
              : 'Register berhasil. Silakan verifikasi OTP.',
        );

        await clearOldLoginSession();
        await _otpSessionService.savePendingOtp(
          email: emailController.text.trim(),
          validSeconds: 60,
        );

        Get.offAllNamed(
          Routes.VERIFY_OTP,
          arguments: {
            'email': email,
          },
        );
      } else {
        Get.snackbar(
          'Gagal',
          result.message.isNotEmpty ? result.message : 'Register gagal',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearOldLoginSession() async {
    final prefs = await SharedPreferences.getInstance();

    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user_id');

    await prefs.setBool('is_logged_in', false);

    await prefs.remove('email');
    await prefs.remove('full_name');
    await prefs.remove('phone');
    await prefs.remove('photo_url');
    await prefs.remove('is_email_verified');
    await prefs.remove('is_face_recognition_active');
    await prefs.remove('has_child_data');
  }
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}