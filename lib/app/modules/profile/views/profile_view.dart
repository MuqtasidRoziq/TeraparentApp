import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/core/widgets/shimmer_loading.dart';
import 'package:teraparent_mobile/app/data/services/user_services.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  static const _primaryColor = Color(0xFF2B5B4B);
  static const _bgLight = Color(0xFFF4F7F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      bottomNavigationBar: BottomNavbar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: _primaryColor,
          onRefresh: () async {
            final userService = Get.find<UserService>();
            await controller.loadProfile();
            await userService.loadUserData();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildProfileShimmer();
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: headerProfile(),
                  ),

                  _buildProfileHeroCard(),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── PROFIL ANAK ───
                        _sectionLabel('Profil Anak'),
                        const SizedBox(height: 12),
                        _buildChildCard(),

                        const SizedBox(height: 24),

                        // ─── RIWAYAT SHORTCUT ───
                        _buildRiwayatButton(),

                        const SizedBox(height: 28),

                        // ─── PENGATURAN AKUN ───
                        _sectionLabel('Pengaturan Akun'),
                        const SizedBox(height: 12),
                        _buildSettingItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Informasi Pribadi',
                          subtitle: 'Nama, telepon, foto profil',
                          onTap: () => Get.toNamed(Routes.INFO_PRIBADI),
                        ),
                        const SizedBox(height: 10),
                        _buildSettingItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Keamanan & Password',
                          subtitle: 'Ganti password, biometrik',
                          onTap: () => Get.toNamed(Routes.SECURITY_PASSWORD),
                        ),

                        const SizedBox(height: 28),

                        // ─── LOGOUT ───
                        _buildLogoutButton(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProfileShimmer() {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              height: 140,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            const SizedBox(height: 24),
            const ShimmerBox(height: 28, width: 180),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 120,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: 24),
            const ShimmerBox(height: 28, width: 160),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: 24),
            const ShimmerBox(height: 28, width: 160),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: 24),
            const ShimmerBox(height: 28, width: 150),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            const SizedBox(height: 16),
            const ShimmerBox(
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileHeroCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B5B4B), Color(0xFF3D8B78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B5B4B).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Avatar
                Obx(() {
                  final photoUrl = Get.find<UserService>().userPhotoUrl.value;
                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 38,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                  );
                }),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.userNameText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Orang Tua',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.INFO_PRIBADI),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Edit Profil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // CHILD CARD
  // ─────────────────────────────────────────────────────────────────
  Widget _buildChildCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Avatar
          Obx(
            () => Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFE8F5F1),
              ),
              clipBehavior: Clip.hardEdge,
              child: controller.childPhotoUrl.value.isNotEmpty
                  ? Image.network(
                      controller.childPhotoUrl.value,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.child_care_rounded,
                        color: Color(0xFF2B5B4B),
                        size: 36,
                      ),
                    )
                  : const Icon(
                      Icons.child_care_rounded,
                      color: Color(0xFF2B5B4B),
                      size: 36,
                    ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.childName.value.isNotEmpty
                        ? controller.childName.value
                        : 'Belum ada profil anak',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                Obx(
                  () => controller.childAge.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            controller.childAge.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 10),
                // Tags indikasi dari screening terbaru
                Obx(() {
                  final hasIndication = controller.indication.value.isNotEmpty;
                  final hasRisk = controller.riskCategory.value.isNotEmpty;
                  if (!hasIndication && !hasRisk) {
                    return const Text(
                      'Belum ada data screening',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (hasIndication)
                        _indicationTag(
                          text: controller.indication.value,
                          bgColor: const Color(0xFFFFF3CD),
                          textColor: const Color(0xFF856404),
                        ),
                      if (hasRisk)
                        _indicationTag(
                          text: controller.riskCategory.value,
                          bgColor: const Color(0xFFD1F2E8),
                          textColor: const Color(0xFF0F6B4F),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.CHILD_DATE),
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // RIWAYAT BUTTON
  // ─────────────────────────────────────────────────────────────────
  Widget _buildRiwayatButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.RIWAYAT),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2B5B4B).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF2B5B4B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Aktivitas',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    'Lihat semua aktivitas harian Ananda',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // SETTING ITEM
  // ─────────────────────────────────────────────────────────────────
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // LOGOUT BUTTON
  // ─────────────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            SizedBox(width: 10),
            Text(
              'Keluar dari Akun',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Keluar dari Akun?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6F5F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda akan keluar dari akun Teraparent.\nPastikan semua aktivitas telah tersimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.logout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: Colors.grey,
      ),
    );
  }

  Widget _indicationTag({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget smallTag({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
