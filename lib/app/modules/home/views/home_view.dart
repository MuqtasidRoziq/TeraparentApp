import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/card_daily_activity.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavbar(),
      body: SafeArea(
        child: Stack(
          children: [
            _topBlur(),
            _bottomBlur(),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => await controller.loadHomeData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 1. HEADER PROFILE — tidak diubah
                      headerProfile(photoUrl: controller.userPhotoUrl.value),
                      const SizedBox(height: 28),

                      // 2. SAPAAN USER
                      _welcomeSection(),
                      const SizedBox(height: 28),

                      _sectionDivider(),
                      _weeklyProgressSection(),

                      const SizedBox(height: 28),

                      _sectionDivider(),
                      _quickMenu(),
                      const SizedBox(height: 28),

                      _sectionDivider(),

                      todayActivityCardStart(
                        title: controller.todayActivity.isNotEmpty
                            ? controller.todayActivity[0].title
                            : 'Belum ada aktivitas hari ini',
                        time: controller.todayActivity.isNotEmpty
                            ? controller.todayActivity[0].timeLabel
                            : '',
                        description: controller.todayActivity.isNotEmpty
                            ? controller.todayActivity[0].description
                            : 'Silakan cek menu Aktivitas untuk melihat daftar aktivitas yang tersedia.',
                        onStartActivity: () {
                          if (controller.todayActivity.isNotEmpty) {
                            final activity = controller.todayActivity[0];
                            Get.toNamed(Routes.DETAIL_ACTIVITY, arguments: activity);
                          }
                        },
                      ),
                      const SizedBox(height: 28),

                      _sectionDivider(),

                      // 6. SCREENING TERAKHIR
                      _lastScreeningSection(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _sectionDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(bottom: 24),
      color: const Color(0xffE8EDEB),
    );
  }

  Widget _welcomeSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, selamat datang',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withOpacity(0.45),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.softGreen.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.child_care_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Ananda: ${controller.childInfoText}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.65),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.family_restroom_rounded,
              color: AppColors.primary, size: 28),
        ),
      ],
    );
  }

  Widget _weeklyProgressSection() {
    return Obx(() {
      final items = controller.weeklyProgress;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Mingguan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            controller.highlightText,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isToday = i == DateTime.now().weekday - 1;
                
                return Expanded(
                  child: _buildProgressBar(
                    day: item.day,
                    value: item.value,
                    height: controller.barHeight(item.value),
                    active: isToday,
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProgressBar({
    required String day,
    required int value,
    required double height,
    bool active = false,
  }) {
    final hasProgress = value > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // label "hari ini"
        SizedBox(
          height: 22,
          child: active
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Hari ini',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 6),
        // batang
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          width: 28,
          height: height.clamp(8.0, 96.0),
          decoration: BoxDecoration(
            color: hasProgress
                ? (active ? AppColors.primary : AppColors.primary.withOpacity(0.6))
                : AppColors.softGreen.withOpacity(0.45),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w900 : FontWeight.w500,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─── 4. MENU CEPAT ───────────────────────────────────────────
  Widget _quickMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Akses fitur utama dengan mudah',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _menuCard(
                title: 'Screening',
                subtitle: 'Cek perkembangan',
                icon: Icons.fact_check_rounded,
                color: AppColors.softGreen,
                onTap: () => Get.toNamed(Routes.SCREENING),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _menuCard(
                title: 'Aktivitas',
                subtitle: 'Latihan harian',
                icon: Icons.playlist_add_check_rounded,
                color: AppColors.softBlue,
                onTap: () => Get.toNamed(Routes.ACTIVITIES),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary.withOpacity(0.55),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lastScreeningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Screening Terakhir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.GRAFIK_PERKEMBANGAN),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffE8EDEB)),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.softGreen, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // status chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.riskCategory.value,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5FAF8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.psychology_alt_rounded,
                        color: AppColors.primary, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Indikasi utama',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.mainIndication.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBlur() {
    return Positioned(
      top: -80,
      right: -60,
      child: Container(
        height: 220,
        width: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.softGreen.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.softGreen.withOpacity(0.45),
              blurRadius: 90,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBlur() {
    return Positioned(
      bottom: 100,
      left: -70,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.lightBlue.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightBlue.withOpacity(0.5),
              blurRadius: 90,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}