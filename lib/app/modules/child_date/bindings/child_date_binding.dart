import 'package:get/get.dart';
import '../controllers/child_date_controller.dart';

class ChildDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildDataController>(
      () => ChildDataController(),
    );
  }
}