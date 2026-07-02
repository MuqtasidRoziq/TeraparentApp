import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/activities/controllers/activities_controller.dart';
import '../controllers/home_controller.dart';
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController()
    );
    Get.lazyPut<ActivitiesController>(
      () => ActivitiesController(),
      fenix: true,
    );
  }
}