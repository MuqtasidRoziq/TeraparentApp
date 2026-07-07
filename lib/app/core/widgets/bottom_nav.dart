import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_controller.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final nav = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    nav.syncWithRoute(Get.currentRoute);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(Icons.home_rounded, "Home", 0),
                _item(Icons.trending_up_rounded, "Grafik", 1),
                _item(Icons.extension_rounded, "konsultasi", 2),
                _item(Icons.person_rounded, "Profile", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    return Obx(() {
      final active = nav.selectedIndex.value == index;
      const activeColor = Color(0xff2F6F57);

      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => nav.changeIndex(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: active ? activeColor.withOpacity(0.14) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: active ? 26 : 24,
                  color: active ? activeColor : Colors.black45,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: active ? activeColor : Colors.black45,
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}