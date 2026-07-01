import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/card_daily_activity.dart';
import 'package:teraparent_mobile/app/core/widgets/header_profile.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import '../controllers/activities_controller.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({super.key});

  String _todayLabel() {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchTodayActivities,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return _buildErrorState();
            }

            final grouped = controller.groupedByDomain;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerProfile(),
                  const SizedBox(height: 30),
                  const Text(
                    'Aktivitas Hari Ini',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202020),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _todayLabel(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (grouped.isEmpty)
                    _buildEmptyState()
                  else
                    ...grouped.entries.map(
                      (entry) => _buildDomainSection(entry.key, entry.value),
                    ),
                  const SizedBox(height: 120),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDomainSection(
    String domain,
    List<DailyActivityModel> domainActivities,
  ) {
    final color = controller.colorForDomain(domain);
    final icon = controller.iconForDomain(domain);
    final label = domainActivities.first.domainLabel;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${domainActivities.length} Aktivitas',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...domainActivities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: activity.isCompleted
                    ? DailyActivityCardSuccess(
                        title: activity.title,
                        time: activity.timeLabel,
                      )
                    : DailyActivityCardNone(
                        title: activity.title,
                        description: activity.description,
                        time: activity.timeLabel,
                        onStart: () => controller.openDetail(activity),
                      ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.event_available, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Belum ada aktivitas terjadwal hari ini',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.fetchTodayActivities,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
