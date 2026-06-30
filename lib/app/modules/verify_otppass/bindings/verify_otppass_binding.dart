import 'package:get/get.dart';

import '../controllers/verify_otppass_controller.dart';

class VerifyOtppassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpPassController>(
      () => VerifyOtpPassController(),
    );
  }
}
