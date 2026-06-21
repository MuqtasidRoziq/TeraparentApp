import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/card_daily_activity.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Stack(
          children: [
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

                  headerProfile(),
                  
                  const SizedBox(height: 30),

                  // ================= GREETING =================
                  // const Text(
                  //   // controller.,
                  //   style: TextStyle(
                  //     fontSize: 34,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xff202020),
                  //   ),
                  // ),

                  const SizedBox(height: 8),

                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ananda: ',
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),

                        TextSpan(
                          text: 'Julio, 4 Tahun',
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
                      border: Border.all(color: Colors.grey.shade200),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            buildBar(40, const Color(0xffB9E7F3), 'SEN'),

                            buildBar(60, const Color(0xff9FD3E2), 'SEL'),

                            buildBar(100, const Color(0xff9FE0C7), 'RAB'),

                            buildBar(50, const Color(0xff87B1A7), 'KAM', true),

                            buildBar(30, Colors.grey.shade200, 'JUM'),

                            buildBar(30, Colors.grey.shade200, 'SAB'),

                            buildBar(30, Colors.grey.shade200, 'MIN'),
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

                  const Text(
                    'Rekomendasi Hari Ini',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 20),

                  DailyActivityCardNone(
                    imageUrl: "https://imgs.search.brave.com/zmlUaqMWUdPH-nO5dtFq2ikoaboiYpI0xjz7FGmKdY8/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdDQu/ZGVwb3NpdHBob3Rv/cy5jb20vNDYwNDMw/NS8yMjkyMS9pLzQ1/MC9kZXBvc2l0cGhv/dG9zXzIyOTIxNDc5/MC1zdG9jay1waG90/by1jaGlsZC1iaWN5/Y2xlLWFzcGhhbHQt/cm9hZC1zdW1tZXIu/anBn",
                    title: 'Bersepeda',
                    description: 'latihan bersepeda untuk melatih keseimbangan dan koordinasi',
                    time: '15.00',
                    onStart: () {
                      Get.toNamed(Routes.DETAIL_ACTIVITY);
                    },
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavbar(),
    );
  }

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
          Icon(icon, size: 30, color: const Color(0xff2F6F57)),

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
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? const Color(0xff2F6F57) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
