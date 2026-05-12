import 'package:get/get.dart';

import '../controllers/security_password_controller.dart';

class SecurityPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityPasswordController>(
      () => SecurityPasswordController(),
    );
  }
}
