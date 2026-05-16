import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isHidden = true.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isHidden.value = !isHidden.value;
  }

  void login() async {

    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email wajib diisi",
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Password wajib diisi",
      );
      return;
    }

    try {

      isLoading.value = true;

      await Future.delayed(
        const Duration(seconds: 2),
      );

      Get.snackbar(
        "Berhasil",
        "Login berhasil",
      );

      Get.offAllNamed(
        Routes.CHILD_DATE,
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


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}