import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';

class BottomNavbar extends GetWidget {
  final RxInt selectedIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 80,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(
              icon: Icons.home_outlined, 
              label: 'Home', 
              index: 0,
              ),
            
            navItem(
              icon: Icons.extension_outlined,
              label: 'Activities',
              index: 1,
            ),

            navItem(
              icon: Icons.trending_up, 
              label: 'Development', 
              index: 2
              ),

            navItem(
              icon: Icons.person_outline, 
              label: 'Profile', 
              index: 3
              ),
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool active = selectedIndex.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(index);
          // Navigate based on selected tab
          switch (index) {
            case 0:
              Get.offAllNamed(Routes.HOME);
              break;
            case 3:
              Get.offAllNamed(Routes.PROFIL);
              break;
            default:
              // For other tabs, you may add routes later
              break;
          }
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: active ? const Color(0xFF2F6F5F) : Colors.grey),

              const SizedBox(height: 4),

              Text(
                label,
                style: TextStyle(
                  color: active ? const Color(0xFF2F6F5F) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
