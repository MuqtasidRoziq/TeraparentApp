import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 1.obs;

  void changeBottomMenu(int index) {
    currentIndex.value = index;
  }
}