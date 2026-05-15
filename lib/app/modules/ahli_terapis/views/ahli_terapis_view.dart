import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ahli_terapis_controller.dart';

class AhliTerapisView extends GetView<AhliTerapisController> {
  const AhliTerapisView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AhliTerapisView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AhliTerapisView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
