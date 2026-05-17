import 'package:get/get.dart';
import '../controllers/home_controller.dart';
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan lazyPut agar controller hanya dibuat saat benar-benar dibutuhkan
    Get.lazyPut<HomeController>(() => HomeController());
  }
}