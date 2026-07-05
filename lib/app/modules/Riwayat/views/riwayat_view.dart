import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/modules/Riwayat/controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D3E26); // Hijau gelap tema aplikasi

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Riwayat Aktivitas",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: primaryColor),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. KELOMPOK STATISTIK RINGKASAN CARD ---
            _buildStatCard(
              count: controller.therapySessionsCount,
              label: "Sesi Terapi Selesai",
              icon: Icons.favorite_border,
              bgColor: const Color(0xFFE6F4EA),
              iconColor: const Color(0xFF137333),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              count: controller.homeActivitiesCount,
              label: "Aktivitas Rumah",
              icon: Icons.home_outlined,
              bgColor: const Color(0xFFE8F0FE),
              iconColor: const Color(0xFF1A73E8),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              count: controller.screeningsCount,
              label: "Skrining Perkembangan",
              icon: Icons.insert_chart_outlined,
              bgColor: const Color(0xFFFEF7E0),
              iconColor: const Color(0xFFB06000),
            ),
            
            const SizedBox(height: 24),

            // --- 2. SEKSI RIWAYAT AKTIVITAS BERDASARKAN WAKTU ---
            const Text("Hari Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildActivityList(controller.todayActivities),
            
            const SizedBox(height: 20),
            const Text("Kemarin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildActivityList(controller.yesterdayActivities),
            
            const SizedBox(height: 20),
            const Text("Minggu Lalu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            _buildActivityList(controller.lastWeekActivities),

            const SizedBox(height: 24),

            // --- 3. BANNER PROMOSI / FUNGSIONAL DI BAWAH ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                // image: const DecorationImage(
                //   // Efek background pattern abstrak opsional
                //   alignment: Alignment.bottomRight,
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pantau Terus Kemajuan\nArka",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Setiap aktivitas kecil yang dilakukan di rumah membawa dampak besar bagi perkembangan buah hati Anda.",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text(
                      "Lihat Analitik Lengkap",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Helper Widget untuk membuat Card Ringkasan Atas
  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "$count",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: iconColor),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: iconColor.withOpacity(0.8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Loop/List Item Aktivitas
  Widget _buildActivityList(List<Map<String, dynamic>> activities) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = activities[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: item['iconBg'],
                child: Icon(item['icon'], color: item['iconColor'], size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          item['time'],
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['child'],
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          item['statusType'] == 'success'
                              ? Icons.check_circle_outline
                              : item['statusType'] == 'info'
                                  ? Icons.assignment_outlined
                                  : Icons.insert_drive_file_outlined,
                          size: 14,
                          color: item['iconColor'],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['status'],
                          style: TextStyle(
                            color: item['iconColor'],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Kustomisasi Bottom Navigation Bar untuk menyelaraskan dengan halaman Progress
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // Fokus aktif pada tab Progress ke-3 sesuai visual mockup
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D3E26),
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Care"),
          const BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Schedule"),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFC8E6C9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bar_chart, color: Color(0xFF0D3E26)),
            ),
            label: "Progress",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}