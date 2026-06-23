import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/navigation_controller.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/login_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/register_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/resend_otp_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/verify-otp_service.dart';
import 'package:teraparent_mobile/app/data/services/child_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teraparent_mobile/app/data/services/auth/otp_session_service.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialRoute = await getInitialRoute();

  Get.put(NavigationController(), permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(RegisterService(), permanent: true);
  Get.put(VerifyOtpService(), permanent: true);
  Get.put(ChildService(), permanent: true);
  Get.put(ResendOtpService(), permanent: true);
  Get.put(LoginService(), permanent: true);
  Get.put(OtpSessionService(), permanent: true);
  Get.put(ScreeningService(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}

Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();

  final token = await storage.read(key: 'token');
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final hasPendingOtp = prefs.getBool('pending_otp') ?? false;
  final pendingEmail = prefs.getString('pending_otp_email');
  final isEmailVerified = readBoolLike(prefs, 'is_email_verified');
  final hasChildData = readBoolLike(prefs, 'has_child_data');

  final validPendingOtp = hasPendingOtp && pendingEmail != null && pendingEmail.isNotEmpty;

  final validLogin = token != null && token.isNotEmpty && isLoggedIn && isEmailVerified;

  if (!validLogin && validPendingOtp) {
    return Routes.VERIFY_OTP;
  }

  debugPrint('is_logged_in : ${prefs.get('is_logged_in')}');
  debugPrint('pending_otp : ${prefs.get('pending_otp')}');
  debugPrint('pending_otp_email : ${prefs.get('pending_otp_email')}');
  debugPrint('is_email_verified : ${prefs.get('is_email_verified')}');
  debugPrint('has_child_data : ${prefs.get('has_child_data')}');
  debugPrint('childId  : ${prefs.get('childId')}');
  debugPrint('chiild_name : ${prefs.get('name')}');

  if (validLogin) {
    await prefs.remove('pending_otp');
    await prefs.remove('pending_otp_email');
    await prefs.remove('pending_otp_expired_at');

    if (hasChildData) {
      return Routes.HOME;
    } else {
      return Routes.CHILD_DATE;
    }
  }

  await clearBrokenSession();

  return Routes.LOGIN;
}

bool readBoolLike(SharedPreferences prefs, String key) {
  final value = prefs.get(key);

  if (value == true) return true;
  if (value == 'true') return true;

  return false;
}

Future<void> clearBrokenSession() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();

  await storage.delete(key: 'token');
  await storage.delete(key: 'user_id');

  await prefs.setBool('is_logged_in', false);

  await prefs.remove('email');
  await prefs.remove('full_name');
  await prefs.remove('phone');
  await prefs.remove('photo_url');
  await prefs.remove('is_email_verified');
  await prefs.remove('is_face_recognition_active');
  await prefs.remove('has_child_data');
}