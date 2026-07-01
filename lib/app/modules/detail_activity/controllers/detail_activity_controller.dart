import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import 'package:teraparent_mobile/app/data/services/activity_services.dart';
import 'package:teraparent_mobile/app/modules/activities/controllers/activities_controller.dart';
import '../../../routes/app_pages.dart';

class DetailActivityController extends GetxController {
  final ActivityService _activityService = Get.find<ActivityService>();

  final isSubmitting = false.obs;
  late final Rxn<DailyActivityModel> activity;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    activity = Rxn<DailyActivityModel>(
      args is DailyActivityModel ? args : null,
    );
  }

  Color get primaryColor {
    switch (activity.value?.domain.toUpperCase()) {
      case 'COMMUNICATION_SPEECH':
        return const Color(0xFF2A6F97);
      case 'SOCIAL_EMOTIONAL':
        return const Color(0xFF8B5E1A);
      case 'COGNITIVE_PROBLEM_SOLVING':
        return const Color(0xFF6A4C93);
      case 'PHYSICAL_MOTOR':
        return const Color(0xFF235A44);
      default:
        return const Color(0xFF235A44);
    }
  }

  /// PATCH /api/activities/:activityId/status -> COMPLETED
  Future<void> submitCompletion() async {
    final current = activity.value;
    if (current == null || isSubmitting.value) return;

    try {
      isSubmitting(true);

      final result = await _activityService.updateActivityStatus(
        activityId: current.id,
        status: 'COMPLETED',
      );

      if (result.success) {
        activity.value = result.data ?? current.copyWith(status: 'COMPLETED');

        // Segarkan daftar aktivitas & progres mingguan di layar sebelumnya
        if (Get.isRegistered<ActivitiesController>()) {
          Get.find<ActivitiesController>().fetchTodayActivities();
        }

        Get.offNamed(Routes.ACTIVITY_SUCCESS, arguments: activity.value);
      } else {
        Get.snackbar(
          'Gagal',
          result.message.isNotEmpty
              ? result.message
              : 'Gagal menyelesaikan aktivitas',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting(false);
    }
  }
}
