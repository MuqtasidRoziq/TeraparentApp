import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/navigation_controller.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/login_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/register_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/resend_otp_service.dart';
import 'package:teraparent_mobile/app/data/services/auth/verify-otp_service.dart';
import 'package:teraparent_mobile/app/data/services/child_service.dart';
import 'app/routes/app_pages.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  Get.put(NavigationController(), permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(RegisterService(), permanent: true);
  Get.put(VerifyOtpService(), permanent: true);
  Get.put(ChildCreateService(), permanent: true);
  Get.put(ResendOtpService(), permanent: true);
  Get.put(LoginService(), permanent: true);
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
