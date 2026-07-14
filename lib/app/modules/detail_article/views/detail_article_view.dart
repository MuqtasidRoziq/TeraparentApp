import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teraparent_mobile/app/core/widgets/shimmer_loading.dart';
import '../controllers/detail_article_controller.dart';

class DetailArticleView extends GetView<DetailArticleController> {
  const DetailArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Artikel",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerDetail();
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState();
          }

          final article = controller.article.value;
          if (article == null) {
            return const Center(child: Text("Artikel tidak ditemukan."));
          }

          final dateFormatted = DateFormat('dd MMMM yyyy').format(article.tanggalPublikasi);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article.kategori,
                        style: const TextStyle(
                          color: Color(0xFF2E5A5A),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateFormatted,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  article.judul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),

                // Abstract graphic banner representing the category since backend doesn't return an image
                _buildCategoryBanner(article.kategori),
                const SizedBox(height: 24),

                // Content
                Text(
                  article.isi,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF334155),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryBanner(String category) {
    IconData iconData = Icons.article_rounded;
    List<Color> colors = [const Color(0xFF2E5A5A), const Color(0xFF1E3A3A)];

    if (category.toLowerCase().contains("speech")) {
      iconData = Icons.record_voice_over_rounded;
      colors = [const Color(0xFF0EA5E9), const Color(0xFF0369A1)];
    } else if (category.toLowerCase().contains("adhd")) {
      iconData = Icons.psychology_rounded;
      colors = [const Color(0xFFF59E0B), const Color(0xFFB45309)];
    } else if (category.toLowerCase().contains("autis")) {
      iconData = Icons.extension_rounded;
      colors = [const Color(0xFFEC4899), const Color(0xFFBE185D)];
    } else if (category.toLowerCase().contains("parent")) {
      iconData = Icons.family_restroom_rounded;
      colors = [const Color(0xFF10B981), const Color(0xFF047857)];
    }

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              iconData,
              size: 160,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(iconData, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text(
                  "Panduan Edukasi: $category",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Disusun oleh Tim Teraparent untuk membantu tumbuh kembang si kecil.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerDetail() {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 16,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 28,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 28,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 28),
            for (int i = 0; i < 6; i++) ...[
              Container(
                height: 16,
                width: i == 5 ? 180 : double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final articleId = Get.arguments as String?;
                if (articleId != null) {
                  controller.fetchArticleDetail(articleId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E5A5A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Coba Lagi", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
