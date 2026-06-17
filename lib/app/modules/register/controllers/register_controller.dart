import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/register%20model.dart';
import 'package:teraparent_mobile/app/data/services/auth/register_service.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RegisterService _registerService = Get.find<RegisterService>();

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

        Get.toNamed(
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