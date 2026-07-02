import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/grafik_model.dart';
import 'package:teraparent_mobile/app/data/services/grafik_services.dart';
import '../../../routes/app_pages.dart';

class GrafikPerkembanganController extends GetxController {
  final GrafikService _grafikService = Get.find<GrafikService>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final childName = 'Ananda'.obs;
  final currentHeight = '-'.obs;
  final currentWeight = '-'.obs;

  final weeklyStats = Rxn<WeeklyActivityStatsModel>();
  final radar = Rxn<ScreeningRadarModel>();
  final screeningTrend = <ScreeningTrendPointModel>[].obs;

  final List<Map<String, String>> milestones = const [
    {"title": "Bisa menumpuk 3 balok", "date": "Tercapai: 12 Okt 2023"},
    {"title": "Mengucapkan 2 kata sekaligus", "date": "Tercapai: 05 Okt 2023"},
    {"title": "Mulai meniru teman sebaya", "date": "Tercapai: 28 Sep 2023"},
  ];

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

      final radarResult = await radarFuture;
      final trendResult = await trendFuture;

      if (weeklyStatsResult.success) {
        weeklyStats.value = weeklyStatsResult.data ?? WeeklyActivityStatsModel.empty();
      }


      if (radarResult.success) {
        radar.value = radarResult.data;
      }

      if (trendResult.success) {
        screeningTrend.assignAll(trendResult.data ?? []);
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
