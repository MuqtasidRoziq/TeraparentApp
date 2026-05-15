import 'package:get/get.dart';

import '../controllers/grafik_perkembangan_controller.dart';

class GrafikPerkembanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GrafikPerkembanganController>(
      () => GrafikPerkembanganController(),
    );
  }
}
