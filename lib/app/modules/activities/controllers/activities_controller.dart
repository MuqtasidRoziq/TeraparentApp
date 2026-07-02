import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import 'package:teraparent_mobile/app/data/services/activity_services.dart';
import '../../../routes/app_pages.dart';

class ActivitiesController extends GetxController {
  final ActivityService _activityService = Get.find<ActivityService>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final activities = <DailyActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayActivities();
  }


  Future<void> fetchTodayActivities() async {
    try {
      isLoading(true);
      errorMessage('');

      final childId = await storage.read(key: 'childId') ?? '';

      if (childId.isEmpty) {
        errorMessage.value = 'Data anak belum ditemukan';
        Get.offAllNamed(Routes.CHILD_DATE);
        return;
      }

      final result = await _activityService.getTodayActivities(
        childId: childId,
      );

      if (result.success) {
        activities.assignAll(result.data ?? []);
      } else {
        errorMessage.value = result.message.isNotEmpty
            ? result.message
            : 'Gagal mengambil aktivitas hari ini';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  Map<String, List<DailyActivityModel>> get groupedByDomain {
    final Map<String, List<DailyActivityModel>> grouped = {};

    for (final activity in activities) {
      grouped.putIfAbsent(activity.domain, () => []).add(activity);
    }

    return grouped;
  }

  IconData iconForDomain(String domain) {
    switch (domain.toUpperCase()) {
      case 'COMMUNICATION_SPEECH':
        return Icons.chat_bubble_outline;
      case 'SOCIAL_EMOTIONAL':
        return Icons.people_outline;
      case 'COGNITIVE_PROBLEM_SOLVING':
        return Icons.psychology_outlined;
      case 'PHYSICAL_MOTOR':
        return Icons.accessibility_new;
      default:
        return Icons.star_outline;
    }
  }

  Color colorForDomain(String domain) {
    switch (domain.toUpperCase()) {
      case 'COMMUNICATION_SPEECH':
        return const Color(0xFF2A6F97);
      case 'SOCIAL_EMOTIONAL':
        return const Color(0xFF8B5E1A);
      case 'COGNITIVE_PROBLEM_SOLVING':
        return const Color(0xFF6A4C93);
      case 'PHYSICAL_MOTOR':
        return const Color(0xFF235A44);
      default:
        return const Color(0xFF2F6F57);
    }
  }

  void openDetail(DailyActivityModel activity) {
    Get.toNamed(Routes.DETAIL_ACTIVITY, arguments: activity);
  }
}
