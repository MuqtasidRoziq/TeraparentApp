import 'package:get/get.dart';

import '../controllers/verify_success_controller.dart';

class VerifySuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VerifySuccessController>(
      VerifySuccessController(),
    );
  }
}
