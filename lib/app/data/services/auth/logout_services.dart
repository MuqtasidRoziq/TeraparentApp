import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

final FlutterSecureStorage _storage = const FlutterSecureStorage();

Future<void> logout() async {
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

  await prefs.remove('pending_otp');
  await prefs.remove('pending_otp_email');
  await prefs.remove('pending_otp_expired_at');

  Get.offAllNamed(Routes.LOGIN);
}
