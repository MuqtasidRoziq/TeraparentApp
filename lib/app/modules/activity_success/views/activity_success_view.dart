import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/routes/app_pages.dart';
import '../controllers/activity_success_controller.dart';

class ActivitySuccessView extends GetView<ActivitySuccessController> {
  const ActivitySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF235A44);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.celebration, size: 100, color: Colors.orangeAccent),
              ),
              const SizedBox(height: 32),
              Obx(
                () => Text(
                  "Hebat! Kamu berhasil\nmenyelesaikan \"${controller.title}\"!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Ayah dan Bunda telah melakukan hal luar biasa hari ini. Mari rayakan langkah kecil ini!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 32),

              // Card domain aktivitas yang baru diselesaikan
              Obx(() {
                if (controller.domainLabel.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEAF4F0),
                        radius: 18,
                        child: Icon(Icons.check_circle, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Aktivitas domain ${controller.domainLabel} telah tercatat",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.lightBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: Colors.lightBlue.withOpacity(0.1),
                  ),
                  onPressed: () => Get.offAllNamed(Routes.GRAFIK_PERKEMBANGAN),
                  icon: const Icon(Icons.bar_chart, color: Colors.lightBlue),
                  label: const Text("Lihat Progres", style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
