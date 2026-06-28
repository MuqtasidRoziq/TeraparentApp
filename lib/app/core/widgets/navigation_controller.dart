import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  final List<String> routes = [
    Routes.HOME,
    Routes.GRAFIK_PERKEMBANGAN,
    Routes.AHLI_TERAPIS,
    Routes.PROFIL,
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
    
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