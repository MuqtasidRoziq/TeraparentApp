import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';

class NavigationBarView extends GetView<NavigationBarController> {
  const NavigationBarView({super.key});

  // Item definitions: icon (outline), icon (filled), label
  static const _items = [
    _NavItem(
      iconOutline: Icons.home_outlined,
      iconFilled: Icons.home_rounded,
      label: 'Beranda',
    ),
    _NavItem(
      iconOutline: Icons.bar_chart_outlined,
      iconFilled: Icons.bar_chart_rounded,
      label: 'Grafik',
    ),
    _NavItem(
      iconOutline: Icons.medical_services_outlined,
      iconFilled: Icons.medical_services_rounded,
      label: 'Konsultasi',
    ),
    _NavItem(
      iconOutline: Icons.person_outline_rounded,
      iconFilled: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    controller.syncWithRoute(Get.currentRoute);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Obx(() {
          return Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _items.length,
                (index) => _buildNavItem(
                  _items[index],
                  index,
                  controller.selectedIndex.value == index,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, int index, bool active) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        HapticFeedback.lightImpact();
        controller.changeIndex(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: active ? 18 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2B5F4E).withOpacity(.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: active ? 1.15 : 1,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                active ? item.iconFilled : item.iconOutline,
                color: active ? const Color(0xFF2B5F4E) : Colors.grey.shade500,
                size: 26,
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: active
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: Color(0xFF2B5F4E),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData iconOutline;
  final IconData iconFilled;
  final String label;

  const _NavItem({
    required this.iconOutline,
    required this.iconFilled,
    required this.label,
  });
}
