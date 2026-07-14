import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/card_daily_activity.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import 'package:teraparent_mobile/app/modules/navigation_bar/views/navigation_bar_view.dart';
import 'package:intl/intl.dart';
import 'package:teraparent_mobile/app/data/models/article_model.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const NavigationBarView(),
      body: SafeArea(
        child: Stack(
          children: [
            _topBlur(),
            _bottomBlur(),
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => await controller.loadHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Obx(() => headerProfile(
                      todayActivities: controller.todayActivity,
                    )),
                    const SizedBox(height: 28),

                    // Sapaan + nama user (data dari backend)
                    _welcomeSection(),
                    const SizedBox(height: 28),

                    _sectionDivider(),
                    _weeklyProgressSection(),

                    const SizedBox(height: 28),

                    _sectionDivider(),
                    _quickMenu(),
                    const SizedBox(height: 28),

                    // Today activity (data dari backend)
                    _todayActivitySection(),

                    _sectionDivider(),
                    _articlesSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
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

  // ─── WELCOME SECTION — hanya teks data yang di-shimmer ───────────
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

              // Nama user — shimmer saat loading
              Obx(() {
                if (controller.isLoading.value) {
                  return ShimmerLoading(
                    child: const ShimmerBox(height: 30, width: 160),
                  );
                }
                return Text(
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
                );
              }),

              const SizedBox(height: 12),

              // Badge nama anak — shimmer saat loading
              Obx(() {
                if (controller.isLoading.value) {
                  return ShimmerLoading(
                    child: const ShimmerBox(
                      height: 32,
                      width: 170,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  );
                }
                return Container(
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
                );
              }),
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

  // ─── WEEKLY PROGRESS — data (angka & teks) di-shimmer, card tetap tampil ─
  Widget _weeklyProgressSection() {
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
          // Judul — selalu tampil
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

          // Circular progress — shimmer saat loading
          Obx(() {
            if (controller.isLoading.value) {
              return ShimmerLoading(
                child: Column(
                  children: const [
                    ShimmerBox(
                      height: 170,
                      width: 170,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    SizedBox(height: 24),
                    ShimmerBox(height: 20, width: 220),
                    SizedBox(height: 15),
                    ShimmerBox(
                      height: 10,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ],
                ),
              );
            }

            final percent = controller.progressPercent / 100;
            return Column(
              children: [
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
            );
          }),
        ],
      ),
    );
  }

  // ─── QUICK MENU — selalu tampil, tidak ada data backend ──────────
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

  // ─── TODAY ACTIVITY — data dari backend, card structure tetap ────
  Widget _todayActivitySection() {
    return Obx(() {
      if (controller.isLoading.value) {
        // Shimmer hanya pada konten dalam card (judul, deskripsi, waktu)
        return ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(height: 22, width: 180),
              SizedBox(height: 12),
              ShimmerBox(height: 14, width: 280),
              SizedBox(height: 8),
              ShimmerBox(height: 14, width: 220),
              SizedBox(height: 20),
              ShimmerBox(
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      }

      if (controller.todayActivity.isEmpty) {
        return Column(
          children: [
            todayActivityCardStart(
              title: 'Belum ada aktivitas hari ini',
              time: '-',
              description:
                  'Silakan cek menu Aktivitas untuk melihat daftar aktivitas yang tersedia.',
              onStartActivity: () {
                Get.toNamed(Routes.ACTIVITIES);
              },
            ),
            const SizedBox(height: 40),
          ],
        );
      }

      final uncompletedActivity =
          controller.todayActivity.firstWhereOrNull((a) => !a.isCompleted);

      if (uncompletedActivity != null) {
        return Column(
          children: [
            todayActivityCardStart(
              title: uncompletedActivity.title,
              time: uncompletedActivity.timeLabel,
              description: uncompletedActivity.description,
              onStartActivity: () {
                Get.toNamed(Routes.DETAIL_ACTIVITY,
                    arguments: uncompletedActivity);
              },
            ),
            const SizedBox(height: 40),
          ],
        );
      } else {
        return Column(
          children: [
            todayActivityCardSuccess(
              title: 'Semua aktivitas selesai!',
              time: 'Hebat!',
              description:
                  'Bunda telah menyelesaikan semua aktivitas harian untuk Ananda hari ini. Teruskan konsistensinya!',
            ),
            const SizedBox(height: 40),
          ],
        );
      }
    });
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

  // ─── ARTICLES SECTION ─────────────────────────────────────────────
  Widget _articlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Artikel Edukasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Tips & info parenting terpercaya',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.ARTICLES),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: const [
                    Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: Color(0xFF2E5A5A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF2E5A5A),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Obx(() {
          if (controller.isLoadingArticles.value) {
            return _buildArticlesShimmer();
          }

          if (controller.articles.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text(
                  "Belum ada artikel tersedia",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            );
          }

          return Column(
            children: controller.articles.map((article) => _buildArticleItem(article)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildArticleItem(ArticleModel article) {
    final dateFormatted = DateFormat('dd MMM yyyy').format(article.tanggalPublikasi);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL_ARTICLE, arguments: article.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8EDEB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4F1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.kategori,
                    style: const TextStyle(
                      color: Color(0xFF2E5A5A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormatted,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article.judul,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              article.isi,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesShimmer() {
    return ShimmerLoading(
      child: Column(
        children: [
          _buildSingleArticleShimmer(),
          _buildSingleArticleShimmer(),
        ],
      ),
    );
  }

  Widget _buildSingleArticleShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 18,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 14,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 16,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}