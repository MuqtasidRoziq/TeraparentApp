import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import 'package:teraparent_mobile/app/core/widgets/bottom_nav.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import '../controllers/grafik_perkembangan_controller.dart';

class GrafikPerkembanganView extends GetView<GrafikPerkembanganController> {
  const GrafikPerkembanganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerProfile(),
                  const SizedBox(height: 24),
                  if (controller.errorMessage.value.isNotEmpty)
                  _buildErrorBanner(),
                  const SizedBox(height: 16),
                  _buildRadarCard(),
                  const SizedBox(height: 16),
                  _buildMilestonesCard(),
                  const SizedBox(height: 16),
                  _buildScreeningTrendCard(),
                  const SizedBox(height: 16),
                  _buildTipsCard(),
                  const SizedBox(height: 80),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Radar Perkembangan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3A20),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const Text(
            "Berdasarkan hasil screening terakhir",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (!controller.hasRadarData)
            _buildEmptyChartState(
              "Anak belum memiliki hasil screening yang selesai.",
            )
          else
            SizedBox(
              height: 220,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: const Color(0xFF147A6A).withOpacity(0.4),
                      borderColor: const Color(0xFF0F3A20),
                      entryRadius: 3,
                      borderWidth: 2,
                      dataEntries: controller.radar.value!.values
                          .map((e) => RadarEntry(value: e))
                          .toList(),
                    ),
                  ],
                  radarShape: RadarShape.polygon,
                  gridBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
                  tickBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
                  tickCount: 3,
                  titlePositionPercentageOffset: 0.15,
                  getTitle: (index, angle) {
                    final labels = controller.radar.value!.labels;
                    return RadarChartTitle(
                      text: index < labels.length ? labels[index] : '',
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 3. Milestones (masih statis - belum ada endpoint backend untuk ini)
  Widget _buildMilestonesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Milestones Terbaru",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F3A20),
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.milestones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = controller.milestones[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFD1E7DD),
                      child: Icon(
                        index == 0
                            ? Icons.widgets
                            : index == 1
                                ? Icons.record_voice_over
                                : Icons.people,
                        color: const Color(0xFF0F3A20),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            item['date']!,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tren Skor Screening",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F3A20)),
          ),
          const Text(
            "5 hasil screening terakhir yang telah selesai",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (controller.screeningTrend.length < 2)
            _buildEmptyChartState(
              "Data screening belum cukup untuk menampilkan tren.",
            )
          else
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final trend = controller.screeningTrend;
                          final index = value.toInt();
                          if (index >= 0 && index < trend.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                trend[index].shortLabel,
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.screeningTrend
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.score))
                          .toList(),
                      isCurved: true,
                      color: const Color(0xFF0F3A20),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyChartState(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ),
    );
  }
  
  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8ECE9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb_outline, color: Color(0xFF147A6A), size: 18),
              SizedBox(width: 6),
              Text(
                "Tips Perkembangan",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF147A6A), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Lanjutkan aktivitas harian secara konsisten agar ${controller.childName.value} "
            "dapat mencapai target minggu ini.",
            style: const TextStyle(color: Color(0xFF2C5550), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
