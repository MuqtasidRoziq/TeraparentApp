import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

import '../../../core/widgets/bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color primaryColor = Color(0xff2F6F57);
  static const Color softGreen = Color(0xffD5F0E5);
  static const Color softBlue = Color(0xffDDF2F8);
  static const Color textDark = Color(0xff1A1A1A);
  static const Color bgColor = Color(0xffF5F7F6); // sedikit lebih hangat dari putih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: BottomNavbar(),
      body: SafeArea(
        child: Stack(
          children: [
            _topBlur(),
            _bottomBlur(),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }

              return RefreshIndicator(
                color: primaryColor,
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

                      // 5. AKTIVITAS HARI INI
                      _todayActivityCard(),
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
                  color: textDark.withOpacity(0.45),
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
                  color: textDark,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: softGreen.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.child_care_rounded,
                        size: 16, color: primaryColor),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Ananda: ${controller.childInfoText}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: primaryColor,
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
              color: primaryColor, size: 28),
        ),
      ],
    );
  }

  Widget _weeklyProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Mingguan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: textDark,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          controller.weeklyProgressText,
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
            children: List.generate(controller.weeklyProgress.length, (i) {
              final item = controller.weeklyProgress[i];
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
                    color: primaryColor,
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
                ? (active ? primaryColor : primaryColor.withOpacity(0.6))
                : softGreen.withOpacity(0.45),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w900 : FontWeight.w500,
            color: active ? primaryColor : Colors.black38,
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
            color: textDark,
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
                color: softGreen,
                onTap: () => Get.toNamed(Routes.SCREENING),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _menuCard(
                title: 'Aktivitas',
                subtitle: 'Latihan harian',
                icon: Icons.playlist_add_check_rounded,
                color: softBlue,
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
                child: Icon(icon, size: 19, color: primaryColor),
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
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: primaryColor.withOpacity(0.55),
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

  // ─── 5. AKTIVITAS HARI INI ───────────────────────────────────
  Widget _todayActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: softBlue, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: softBlue.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Hari Ini',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: softBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.record_voice_over_rounded,
                    color: primaryColor, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.activityTitle.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            color: primaryColor, size: 15),
                        const SizedBox(width: 5),
                        Text(
                          controller.activityDuration.value,
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            controller.activityDescription.value,
            style: const TextStyle(
              color: Color(0xff555555),
              fontSize: 13.5,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.DETAIL_ACTIVITY),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mulai Aktivitas',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_circle_fill_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 6. SCREENING TERAKHIR ───────────────────────────────────
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
                color: textDark,
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
                    size: 14, color: primaryColor),
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
            border: Border.all(color: softGreen, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // status chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: softGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.riskCategory.value,
                  style: const TextStyle(
                    color: primaryColor,
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
                        color: primaryColor, size: 26),
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
                            color: textDark,
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

  // ─── BACKGROUND ──────────────────────────────────────────────
  Widget _topBlur() {
    return Positioned(
      top: -80,
      right: -60,
      child: Container(
        height: 220,
        width: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xffB8F2DF).withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffB8F2DF).withOpacity(0.45),
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
          color: const Color(0xffD8F7FF).withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffD8F7FF).withOpacity(0.5),
              blurRadius: 90,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}