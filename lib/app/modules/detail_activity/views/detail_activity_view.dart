import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_activity_controller.dart';

class DetailActivityView extends GetView<DetailActivityController> {
  const DetailActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF235A44)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Detail Aktivitas",
          style: TextStyle(
            color: Color(0xFF235A44),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final act = controller.activity.value;

        if (act == null) {
          return const Center(child: Text("Data aktivitas tidak ditemukan"));
        }

        final primaryColor = controller.primaryColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ilustrasi (backend belum menyediakan gambar per aktivitas)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: primaryColor.withOpacity(0.1),
                  child: Icon(Icons.image, size: 80, color: primaryColor),
                ),
              ),
              const SizedBox(height: 16),

              // Badge Domain, Durasi, & Tingkat Kesulitan
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    act.domainLabel,
                    primaryColor.withOpacity(0.15),
                    primaryColor,
                    Icons.directions_run,
                  ),
                  _buildBadge(
                    act.durationLabel,
                    Colors.blueGrey.withOpacity(0.1),
                    Colors.blueGrey,
                    Icons.access_time,
                  ),
                  _buildBadge(
                    act.difficulty,
                    Colors.orange.withOpacity(0.1),
                    Colors.orange.shade800,
                    Icons.bar_chart,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Judul & Deskripsi
              Text(
                act.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                act.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
              ),
              const SizedBox(height: 20),

              // Card Tujuan Latihan
              _buildSectionCard(
                title: "Tujuan Latihan",
                icon: Icons.assignment_turned_in_outlined,
                color: primaryColor,
                child: Text(
                  act.purpose,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),

              if (act.toolsNeeded.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: "Alat yang Dibutuhkan",
                  icon: Icons.build_outlined,
                  color: primaryColor,
                  child: Column(
                    children: act.toolsNeeded.map((tool) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(tool, style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              if (act.parentTips != null && act.parentTips!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.security, color: Color(0xFF7A6021), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Tips untuk Orang Tua",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A6021),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        act.parentTips!,
                        style: const TextStyle(color: Color(0xFF7A6021), height: 1.4, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Langkah-langkah
              if (act.steps.isNotEmpty) ...[
                Text(
                  "Langkah-langkah",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 12),
                Column(
                  children: List.generate(act.steps.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: primaryColor,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              act.steps[index],
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],

              if (act.successIndicator.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: "Indikator Keberhasilan",
                  icon: Icons.emoji_events_outlined,
                  color: primaryColor,
                  child: Text(
                    act.successIndicator,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Tombol Selesaikan Aktivitas
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: act.isCompleted ? Colors.grey : primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: (act.isCompleted || controller.isSubmitting.value)
                      ? null
                      : () => controller.submitCompletion(),
                  icon: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    act.isCompleted ? "Aktivitas Selesai" : "Selesaikan Aktivitas",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
