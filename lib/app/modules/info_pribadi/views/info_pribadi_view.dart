import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/info_pribadi_controller.dart';

class InfoPribadiView extends GetView<InfoPribadiController> {
  const InfoPribadiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InfoPribadiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InfoPribadiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
