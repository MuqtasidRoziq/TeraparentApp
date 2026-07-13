import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/navigation_bar/views/navigation_bar_view.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/core/widgets/therapist_card.dart';

import '../controllers/ahli_terapis_controller.dart';

class AhliTerapisView extends GetView<AhliTerapisController> {
  const AhliTerapisView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            headerProfile(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 20),

            // Filter kategori
            Obx(() => _buildCategoryFilter()),

            const SizedBox(height: 24),
            _buildSectionHeader(),
            const SizedBox(height: 16),

            // List terapis
            Obx(() {
              return Column(
                children: controller.therapists.map((data) {
                  return TherapistCard(therapist: data);
                }).toList(),
              );
            }),

            const SizedBox(height: 8),
            _buildHelpFilterBanner(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarView(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Cari terapis, spesialisasi, atau lokasi...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ["Semua", "Wicara", "Okupasi", "Fisioterapi"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          bool isSelected = controller.selectedCategory.value == cat;
          return GestureDetector(
            onTap: () => controller.changeCategory(cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2E5A5A)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Terapis Rekomendasi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Row(
            children: [
              Text(
                "Lihat Peta ",
                style: TextStyle(
                  color: Color(0xFF2E5A5A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Icon(Icons.map_outlined, color: Color(0xFF2E5A5A), size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpFilterBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Butuh bantuan mencari?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Gunakan filter lanjutan untuk hasil lebih spesifik.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5A5A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.tune, size: 18),
            label: const Text(
              "Filter",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
