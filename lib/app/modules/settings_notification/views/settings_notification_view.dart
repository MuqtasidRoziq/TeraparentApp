import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_notification_controller.dart';

class SettingsNotificationView extends GetView<SettingsNotificationController> {
  const SettingsNotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsNotificationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingsNotificationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
