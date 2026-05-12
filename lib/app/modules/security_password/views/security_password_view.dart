import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/security_password_controller.dart';

class SecurityPasswordView extends GetView<SecurityPasswordController> {
  const SecurityPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecurityPasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SecurityPasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
