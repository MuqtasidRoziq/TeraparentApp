import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class VerifySuccessController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();

    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 2), () async {
      if (isClosed || Get.currentRoute != Routes.VERIFY_SUCCESS) return;

      final prefs = await SharedPreferences.getInstance();

      final hasChildData = prefs.getBool('has_child_data') ?? false;

      print('VERIFY SUCCESS REDIRECT');
      print('has_child_data: $hasChildData');

      if (hasChildData) {
        Get.offAllNamed(Routes.HOME);
      } else {
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