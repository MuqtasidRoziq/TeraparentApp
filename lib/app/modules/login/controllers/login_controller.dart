import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/auth/login_model.dart';
import 'package:teraparent_mobile/app/data/services/auth/login_service.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import 'package:teraparent_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';

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
        final SharedPreferences prefs= await SharedPreferences.getInstance();
        final token = result.data!.token;
        final user = result.data!.user;
        final child = user.children.first;
        final latestResult = user.resultScreening.isNotEmpty
            ? user.resultScreening.first
            : null;

        Get.snackbar(
          'Success', 
          result.message.isEmpty ?
          result.message : 'Login berhasil'
        );


        await storage.write(key: 'token', value: token);
        await storage.write(key: 'user_id', value: user.id);
        await storage.write(key: 'childId', value: child.id);
        
        await prefs.setString('email', user.email);
        await prefs.setString('full_name', user.fullName);
        await prefs.setString('phone', user.phone ?? '');
        await prefs.setString("photo_url", user.profileImage ?? '');
        await prefs.setBool('is_logged_in', true);
        await prefs.setBool('is_email_verified', user.isEmailVerified);
        await prefs.setBool('is_face_recognition_active', user.isFaceRecognitionActive);
        await prefs.setBool('has_child_data', user.hasChildData);
        await prefs.setString('childName', child.childName);
        await prefs.setString('gender', child.gender);
        await prefs.setString('birthDate', child.birthDate.toString());
        await prefs.setDouble('weightKg', child.weightKg);
        await prefs.setDouble('heightCm', child.heightCm);
        if (latestResult != null) {
          await prefs.setString(
            'mainIndication',
            latestResult.mainIndication,
          );
          await prefs.setString(
            'priorityDomain',
            latestResult.priorityDomain,
          );
          await prefs.setString(
            'riskCategory',
            latestResult.riskCategory,
          );
        } else {
          await prefs.remove('mainIndication');
          await prefs.remove('priorityDomain');
          await prefs.remove('riskCategory');
        }

        Get.find<NavigationBarController>().reset();
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
        Get.snackbar(
          'Error', 
          'Login gagal: $e',
        );
        print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}