import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

class NavigationBarController extends GetxController {
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    changeIndex(0);
  }

  final List<String> routes = [
    Routes.HOME,
    Routes.GRAFIK_PERKEMBANGAN,
    Routes.AHLI_TERAPIS,
    Routes.PROFIL,
  ];

  void changeIndex(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    final route = routes[index];

    if (Get.currentRoute != route) {
      Future.microtask(() {
        Get.offNamed(route);
      });
    }
  }

  void reset() {
    selectedIndex.value = 0;
  }

  void syncWithRoute(String route) {
    final index = routes.indexOf(route);
    if (index != -1 && selectedIndex.value != index) {
      selectedIndex.value = index;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
