import 'package:get/get.dart';

import '../controllers/info_pribadi_controller.dart';

class InfoPribadiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoPribadiController>(
      () => InfoPribadiController(),
    );
  }
}
