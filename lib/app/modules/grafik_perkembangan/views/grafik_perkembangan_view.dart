import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/grafik_perkembangan_controller.dart';

class GrafikPerkembanganView extends GetView<GrafikPerkembanganController> {
  const GrafikPerkembanganView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrafikPerkembanganView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GrafikPerkembanganView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
