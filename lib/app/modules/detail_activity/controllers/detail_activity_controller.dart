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

  // Form fields for completion
  final childResponseController = TextEditingController();
  final parentNoteController = TextEditingController();
  final selectedSuccessLevel = 3.obs; // default 3 out of 5

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    activity = Rxn<DailyActivityModel>(
      args is DailyActivityModel ? args : null,
    );
  }

  @override
  void onClose() {
    childResponseController.dispose();
    parentNoteController.dispose();
    super.onClose();
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

  /// Show the completion form bottom sheet
  void showCompletionForm(BuildContext context) {
    // Reset form
    childResponseController.clear();
    parentNoteController.clear();
    selectedSuccessLevel.value = 3;

    Get.bottomSheet(
      _CompletionFormSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// PATCH /api/activities/:activityId/status -> COMPLETED
  Future<void> submitCompletion() async {
    final current = activity.value;
    if (current == null || isSubmitting.value) return;

    try {
      isSubmitting(true);

      // Build the note payload from form fields
      final note = ActivityNoteRequestModel(
        childResponse: childResponseController.text.trim().isNotEmpty
            ? childResponseController.text.trim()
            : null,
        successLevel: selectedSuccessLevel.value,
        parentNote: parentNoteController.text.trim().isNotEmpty
            ? parentNoteController.text.trim()
            : null,
      );

      final result = await _activityService.updateActivityStatus(
        activityId: current.id,
        status: 'COMPLETED',
        note: note,
      );

      if (result.success) {
        activity.value = result.data ?? current.copyWith(status: 'COMPLETED');

        // Close the bottom sheet first
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        // Refresh activity list on previous screen
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

/// Bottom sheet form widget for completion notes
class _CompletionFormSheet extends StatelessWidget {
  final DetailActivityController controller;

  const _CompletionFormSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final color = controller.primaryColor;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit_note_rounded, color: color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Catat Hasil Aktivitas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Isi catatan sebelum menyelesaikan',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 1. Tingkat Keberhasilan
                  const Text(
                    'Tingkat Keberhasilan Anak',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seberapa berhasil anak dalam melakukan aktivitas ini?',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final level = i + 1;
                      final isSelected = level <= controller.selectedSuccessLevel.value;
                      return GestureDetector(
                        onTap: () => controller.selectedSuccessLevel.value = level,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            children: [
                              Icon(
                                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade300,
                                size: 36,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$level',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? color : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )),
                  const SizedBox(height: 24),

                  // 2. Respon Anak
                  const Text(
                    'Respon Anak',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bagaimana respon anak saat melakukan aktivitas?',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.childResponseController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Anak antusias, bisa mengikuti 3 dari 5 langkah...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: color, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Catatan Orang Tua
                  const Text(
                    'Catatan Orang Tua',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Catatan tambahan atau kendala yang dihadapi',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.parentNoteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Anak sedikit rewel di awal, tapi setelah itu mau...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: color, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.submitCompletion(),
                      icon: controller.isSubmitting.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_rounded, color: Colors.white),
                      label: Text(
                        controller.isSubmitting.value
                            ? 'Menyimpan...'
                            : 'Selesaikan Aktivitas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 12),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
