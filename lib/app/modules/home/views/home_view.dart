import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/card_daily_activity.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/shimmer_loading.dart';
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
                return _buildHomeShimmer();
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

                      headerProfile(),
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
                      
                      Builder(builder: (context) {
                        if (controller.todayActivity.isEmpty) {
                          return todayActivityCardStart(
                            title: 'Belum ada aktivitas hari ini',
                            time: '-',
                            description: 'Silakan cek menu Aktivitas untuk melihat daftar aktivitas yang tersedia.',
                            onStartActivity: () {
                              Get.toNamed(Routes.ACTIVITIES);
                            },
                          );
                        }

                        final uncompletedActivity = controller.todayActivity
                            .firstWhereOrNull((a) => !a.isCompleted);

                        if (uncompletedActivity != null) {
                          return todayActivityCardStart(
                            title: uncompletedActivity.title,
                            time: uncompletedActivity.timeLabel,
                            description: uncompletedActivity.description,
                            onStartActivity: () {
                              Get.toNamed(Routes.DETAIL_ACTIVITY, arguments: uncompletedActivity);
                            },
                          );
                        } else {
                          return todayActivityCardSuccess(
                            title: 'Semua aktivitas selesai!',
                            time: 'Hebat!',
                            description: 'Bunda telah menyelesaikan semua aktivitas harian untuk Ananda hari ini. Teruskan konsistensinya!',
                          );
                        }
                      }),
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

  Widget _buildHomeShimmer() {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const ShimmerBox(height: 110, borderRadius: BorderRadius.all(Radius.circular(28))),
            const SizedBox(height: 28),
            const ShimmerBox(height: 28, width: 220),
            const SizedBox(height: 16),
            const ShimmerBox(height: 220, borderRadius: BorderRadius.all(Radius.circular(28))),
            const SizedBox(height: 28),
            const ShimmerBox(height: 28, width: 180),
            const SizedBox(height: 16),
            const ShimmerBox(height: 130, borderRadius: BorderRadius.all(Radius.circular(24))),
            const SizedBox(height: 28),
            const ShimmerBox(height: 28, width: 160),
            const SizedBox(height: 16),
            const ShimmerBox(height: 160, borderRadius: BorderRadius.all(Radius.circular(24))),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
      final percent = controller.progressPercent / 100;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [

            /// Judul
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Progress Minggu Ini",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            CircularPercentIndicator(
              radius: 85,
              lineWidth: 14,
              animation: true,
              animationDuration: 1200,
              percent: percent.clamp(0.0, 1.0),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.green.shade50,
              progressColor: AppColors.primary,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    controller.progressPercentText,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Progress",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              controller.highlightText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: percent,
                backgroundColor: Colors.green.shade50,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    });
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