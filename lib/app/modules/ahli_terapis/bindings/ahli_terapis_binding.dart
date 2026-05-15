import 'package:get/get.dart';

import '../controllers/ahli_terapis_controller.dart';

class AhliTerapisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AhliTerapisController>(
      () => AhliTerapisController(),
    );
  }
}
