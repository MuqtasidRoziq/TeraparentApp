import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import 'package:teraparent_mobile/app/data/models/grafik_model.dart';
import 'package:teraparent_mobile/app/data/models/screening_model.dart';
import 'package:teraparent_mobile/app/data/services/grafik_services.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';
import 'package:teraparent_mobile/app/modules/activities/controllers/activities_controller.dart';

class HomeController extends GetxController {

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late final ActivitiesController activitiesController;
  final GrafikService _weeklyProggresStats = Get.find<GrafikService>();
  final ScreeningService _screeningService = Get.find<ScreeningService>();
  
  final isLoading = false.obs;
  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final childName = ''.obs;
  final childAgeText = ''.obs;
  final mainIndication = ''.obs;
  final riskCategory = ''.obs;
  final priorityDomain = ''.obs;
  
  final todayActivity = <DailyActivityModel>[].obs;
  final weeklyStats = Rxn<WeeklyActivityStatsModel>();
  final lastScreening = Rxn<ScreeningResultModel>();

  @override
  void onInit() {
    activitiesController = Get.find<ActivitiesController>();
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();

      userName.value = prefs.getString('full_name') ?? 'Bunda';
      userPhotoUrl.value = prefs.getString('photo_url') ?? '';
      childName.value = prefs.getString('childName') ?? 'Belum ada data anak';
      final childId = await storage.read(key: 'childId') ?? '';

      if (childId.isNotEmpty) {
        final weeklyProgress = await _weeklyProggresStats.getActivityStats(childId: childId);
        if (weeklyProgress.success) {
          weeklyStats.value = weeklyProgress.data ?? WeeklyActivityStatsModel.empty();
        }
      }

      await fetchLastScreening(childId);

      await setActivityByScreening();
      
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLastScreening(String childId) async {
    try {
      final result =  await _screeningService.getHistory(childId: childId);

      if (!result.success || result.data == null) return;

      if (result.data!.isEmpty) return;

      final latest = result.data!.last;
      mainIndication.value = formatMainIndication(latest.mainIndication);
      riskCategory.value = latest.riskCategory;
      priorityDomain.value = latest.priorityDomain;

    } catch (e) {
      print(e);
    }
  }
  

  Future<void> setActivityByScreening() async {
    await activitiesController.fetchTodayActivities();
    todayActivity.assignAll(
      activitiesController.activities.where((e) => !e.isCompleted),
    );

  }

  int get completedActivity => weeklyStats.value?.completedActivity ?? 0;
  int get totalActivity => weeklyStats.value?.totalActivity ?? 0;
  double get progressPercent => weeklyStats.value?.progressPercent ?? 00.00;
  int get remainingActivity => totalActivity - completedActivity;

  String get progressPercentText{ 
    return '${(progressPercent).toStringAsFixed(2)}%'; 
  }

  String get highlightText {
    if (weeklyStats.value == null || totalActivity == 0) {
      return '${childName.value} belum memiliki aktivitas mingguan yang tercatat.';
    }

    return '${childName.value} telah menyelesaikan $completedActivity dari $totalActivity';
  }

  String get firstName {
    if (userName.value.trim().isEmpty) return 'Bunda';
    return userName.value.trim().split(' ').first;
  }

  String get childInfoText {
    if (childName.value.isEmpty || childName.value == 'Belum ada data anak') {
      return 'Belum ada data anak';
    }
    if (childAgeText.value.isEmpty || childAgeText.value == '-') {
      return childName.value;
    }
    return '${childName.value}, ${childAgeText.value}';
  }

  // int get weeklyTarget => 7;

  double barHeight(int value) {
    if (value <= 0) return 30;
    return 92;
  }

  String formatMainIndication(String? value) {
    switch (value?.toUpperCase().trim()) {
      case 'SPEECH_DELAY':
        return 'Speech Delay';
      case 'AUTISM':
        return 'Autisme Spectrum';
      case 'ADHD':
        return 'ADHD';
      case 'DEVELOPMENT_CONCERN':
        return 'Perhatian Tingkat Lanjut';
      default:
        return 'Belum ada indikasi utama harap melakukan screening terlebih dahulu';
    }
  }
}