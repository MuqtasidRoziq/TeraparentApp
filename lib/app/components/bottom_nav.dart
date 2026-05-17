import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final nav = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(Icons.home, "Home", 0),
          _item(Icons.extension, "Activity", 1),
          _item(Icons.trending_up, "Grafik", 2),
          _item(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon, 
    String label, 
    int index) {
    return Obx(() {
      final active = nav.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => nav.changeIndex(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? const Color(0xff2F6F57) : Colors.black54,
            ),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xff2F6F57) : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    });
  }
}