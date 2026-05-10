import 'package:get/get.dart';

class ProfileController extends GetxController {

  RxInt selectedIndex = 3.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}