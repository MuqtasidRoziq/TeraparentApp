import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/login_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/login_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final LoginService _loginService = Get.find<LoginService>();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  var isHidden = true.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email wajib diisi');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Format email tidak valid');
      return;
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Password wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      final request = LoginRequestModel(
        email: email, 
        password: password
        );

       final result = await _loginService.login(
        request: request
      );

      if (result.success) {
        final token = result.data!.token;
        // final user = result.data!.user;

        Get.snackbar(
          'Success', 
          result.message.isEmpty ?
          result.message : 'Login berhasil'
        );

       Get.offAllNamed(Routes.HOME);

        await storage.write(key: 'token', value: token);

      }
        // await storage.write(key: 'user', value: user.toJson().toString());
    } catch (e) {
        Get.snackbar(
          'Error', 
          'Login gagal: $e'
        );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}