import 'dart:async';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class VerifySuccessController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();

    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!isClosed && Get.currentRoute == Routes.VERIFY_SUCCESS) {
        Get.offAllNamed(Routes.CHILD_DATE);
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}