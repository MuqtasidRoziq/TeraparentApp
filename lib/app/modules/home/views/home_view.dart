import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      // ================= BODY =================
      body: SafeArea(
        child: Stack(
          children: [

            // ================= BLUR TOP =================
            Positioned(
              top: -70,
              right: -70,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffB8F2DF).withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffB8F2DF).withOpacity(0.7),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),

            // ================= BLUR BOTTOM =================
            Positioned(
              bottom: 120,
              left: -60,
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffD8F7FF).withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffD8F7FF).withOpacity(0.8),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),

            // ================= CONTENT =================
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [

                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.green.shade200,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            'Teraparent',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2F6F57),
                            ),
                          ),
                        ],
                      ),

                      const Icon(Icons.notifications_none_rounded),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= GREETING =================
                  const Text(
                    'Selamat datang,\nOrang Tua 👋',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202020),
                    ),
                  ),

                  const SizedBox(height: 8),

                  RichText(
                    text: const TextSpan(
                      children: [

                        TextSpan(
                          text: 'Ananda: ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),

                        TextSpan(
                          text: 'Ararya, 5 Tahun',
                          style: TextStyle(
                            color: Color(0xff2F6F57),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= PROGRESS CARD =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: const [

                                Text(
                                  'Progres Mingguan',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 6),

                                Text(
                                  'Aktivitas meningkat 12% dari minggu\nlalu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),

                            const Icon(
                              Icons.bar_chart,
                              color: Color(0xff2F6F57),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [

                            buildBar(
                              40,
                              const Color(0xffB9E7F3),
                              'SEN',
                            ),

                            buildBar(
                              60,
                              const Color(0xff9FD3E2),
                              'SEL',
                            ),

                            buildBar(
                              100,
                              const Color(0xff9FE0C7),
                              'RAB',
                            ),

                            buildBar(
                              50,
                              const Color(0xff87B1A7),
                              'KAM',
                              true,
                            ),

                            buildBar(
                              30,
                              Colors.grey.shade200,
                              'JUM',
                            ),

                            buildBar(
                              30,
                              Colors.grey.shade200,
                              'SAB',
                            ),

                            buildBar(
                              30,
                              Colors.grey.shade200,
                              'MIN',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================= MENU =================
                  Row(
                    children: [

                      // SCREENING
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.SCREENING);
                          },
                          child: menuCard(
                            title: 'Mulai\nScreening',
                            icon: Icons.fact_check_outlined,
                            color: const Color(0xffD5F0E5),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // INPUT AKTIVITAS
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.ACTIVITIES);
                          },
                          child: menuCard(
                            title: 'Input\nAktivitas',
                            icon: Icons.playlist_add_check,
                            color: const Color(0xffDDF2F8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [

                      // GRAFIK
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.GRAFIK_PERKEMBANGAN);
                          },
                          child: menuCard(
                            title: 'Grafik\nPerkembangan',
                            icon: Icons.trending_up,
                            color: const Color(0xffEDF3F1),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // KONSULTASI
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.AHLI_TERAPIS);
                          },
                          child: menuCard(
                            title: 'Konsultasi\nAhli Psikologi',
                            icon: Icons.chat_bubble_outline,
                            color: const Color(0xffEAEAEA),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ================= TITLE =================
                  const Text(
                    'Rekomendasi Hari Ini',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [

              navItem(
                icon: Icons.home_outlined,
                title: 'Home',
                index: 0,
              ),

              navItem(
                icon: Icons.extension,
                title: 'Activities',
                index: 1,
              ),

              navItem(
                icon: Icons.trending_up,
                title: 'GRAFIK',
                index: 2,
              ),

              navItem(
                icon: Icons.person_outline,
                title: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MENU CARD =================
Widget menuCard({
  required String title,
  required IconData icon,
  required Color color,
}) {
  return Container(
    height: 140,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(28),
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Icon(
          icon,
          size: 30,
          color: const Color(0xff2F6F57),
        ),

        const Spacer(),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff2F6F57),
          ),
        ),
      ],
    ),
  );
}

// ================= BAR =================
Widget buildBar(
  double height,
  Color color,
  String day, [
  bool active = false,
]) {
  return Column(
    children: [

      Container(
        width: 28,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      const SizedBox(height: 10),

      Text(
        day,
        style: TextStyle(
          fontSize: 12,
          fontWeight:
              active
                  ? FontWeight.bold
                  : FontWeight.w500,
          color:
              active
                  ? const Color(0xff2F6F57)
                  : Colors.grey,
        ),
      ),
    ],
  );
}

// ================= NAV ITEM =================
Widget navItem({
  required IconData icon,
  required String title,
  required int index,
}) {
  final HomeController controller = Get.find();

  final isActive =
      controller.currentIndex.value == index;

  return GestureDetector(
    onTap: () {
      controller.changeBottomMenu(index);

      if (index == 0) {
        Get.toNamed(Routes.HOME);
      } else if (index == 1) {
        Get.toNamed(Routes.ACTIVITIES);
      } else if (index == 2) {
        Get.toNamed(Routes.GRAFIK_PERKEMBANGAN);
      } else if (index == 3) {
        Get.toNamed(Routes.PROFIL);
      }
    },

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:
            isActive
                ? const Color(0xffB8EBCF)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 22,
            color:
                isActive
                    ? const Color(0xff2F6F57)
                    : Colors.black54,
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  isActive
                      ? const Color(0xff2F6F57)
                      : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}