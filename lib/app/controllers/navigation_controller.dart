// 

import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  final List<String> routes = [
    Routes.HOME,
    Routes.ACTIVITIES,
    Routes.GRAFIK_PERKEMBANGAN,
    Routes.PROFIL,
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;

    // delay kecil biar Obx update dulu
    Future.microtask(() {
      Get.toNamed(routes[index]);
    });
  }

  void syncWithRoute(String route) {
    final index = routes.indexOf(route);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }
}