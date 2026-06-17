import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpController>(
      () => VerifyOtpController(),
    );
  }

  void sharedPreference() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    
    Get.lazyPut<SharedPreferences>(
      () => sharedPreferences
    );
  }
  
}
