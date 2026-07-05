import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/grafik_model.dart';
import 'package:teraparent_mobile/app/data/services/grafik_services.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import 'package:teraparent_mobile/app/data/services/activity_services.dart';
import 'package:teraparent_mobile/app/data/models/screening_model.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';
import '../../../routes/app_pages.dart';

class GrafikPerkembanganController extends GetxController {
  final GrafikService _grafikService = Get.find<GrafikService>();
  final ActivityService _activityService = Get.find<ActivityService>();
  final ScreeningService _screeningService = Get.find<ScreeningService>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final childName = 'Ananda'.obs;
  final currentHeight = '-'.obs;
  final currentWeight = '-'.obs;

  final weeklyStats = Rxn<WeeklyActivityStatsModel>();
  final radar = Rxn<ScreeningRadarModel>();
  final screeningTrend = <ScreeningTrendPointModel>[].obs;
  final screeningHistory = <ScreeningResultModel>[].obs;
  
  final recentActivities = <DailyActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading(true);
      errorMessage('');

      final prefs = await SharedPreferences.getInstance();
      childName.value = prefs.getString('childName') ?? 'Ananda';

      final childId = await storage.read(key: 'childId') ?? '';

      if (childId.isEmpty || childId.isEmpty) {
        errorMessage.value = 'Data anak belum ditemukan';
        Get.offAllNamed(Routes.CHILD_DATE);
        return;
      }

      final weeklyStatsResult = await _grafikService.getActivityStats(childId: childId);
      final radarFuture = _grafikService.getLastScreeningStats(childId: childId);
      final trendFuture = _grafikService.getScreeningHistoryStats(childId: childId);
      final activityFuture = _activityService.getActivityHistory(childId: childId, status: 'COMPLETED');
      final historyFuture = _screeningService.getHistory(childId: childId);

      final radarResult = await radarFuture;
      final trendResult = await trendFuture;
      final activityResult = await activityFuture;
      final historyResult = await historyFuture;

      if (weeklyStatsResult.success) {
        weeklyStats.value = weeklyStatsResult.data ?? WeeklyActivityStatsModel.empty();
      }


      if (radarResult.success) {
        radar.value = radarResult.data;
      }

      if (trendResult.success) {
        screeningTrend.assignAll(trendResult.data ?? []);
      }

      if (activityResult.success) {
        recentActivities.assignAll(activityResult.data ?? []);
      }

      if (historyResult.success) {
        final completed = historyResult.data?.where((e) => e.status == 'COMPLETED').toList() ?? [];
        completed.sort((a, b) {
          if (a.completedAt == null && b.completedAt == null) return 0;
          if (a.completedAt == null) return 1;
          if (b.completedAt == null) return -1;
          return b.completedAt!.compareTo(a.completedAt!);
        });
        screeningHistory.assignAll(completed.take(5).toList());
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  bool get hasRadarData => radar.value != null && !radar.value!.isEmpty;

  double get progressPercent => weeklyStats.value?.progressPercent ?? 0;
  int get completedActivity => weeklyStats.value?.completedActivity ?? 0;
  int get totalActivity => weeklyStats.value?.totalActivity ?? 0;

  String get highlightText {
    if (weeklyStats.value == null || totalActivity == 0) {
      return '${childName.value} belum memiliki aktivitas mingguan yang tercatat.';
    }

    return '${childName.value} telah menyelesaikan $completedActivity dari '
        '$totalActivity aktivitas minggu ini (${progressPercent.toStringAsFixed(0)}%).';
  }
}
