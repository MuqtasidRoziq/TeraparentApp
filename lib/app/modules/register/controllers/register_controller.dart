import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isChecked = false.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  void register() async {

    if (nameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Nama lengkap wajib diisi",
      );
      return;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Email wajib diisi",
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password minimal 6 karakter",
      );
      return;
    }

    if (!isChecked.value) {
      Get.snackbar(
        "Error",
        "Anda harus menyetujui ketentuan",
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
        "Akun berhasil dibuat",
      );
      
      Get.offAllNamed(Routes.LOGIN);

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}