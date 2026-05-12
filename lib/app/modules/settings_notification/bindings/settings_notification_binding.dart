import 'package:get/get.dart';

import '../controllers/settings_notification_controller.dart';

class SettingsNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsNotificationController>(
      () => SettingsNotificationController(),
    );
  }
}
