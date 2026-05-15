import 'package:get/get.dart';

class ActivitiesController extends GetxController {

  // index bottom navigation
  RxInt currentIndex = 1.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}