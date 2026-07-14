import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import 'package:teraparent_mobile/app/data/models/grafik_model.dart';
import 'package:teraparent_mobile/app/data/models/article_model.dart';
import 'package:teraparent_mobile/app/data/services/article_service.dart';
import 'package:teraparent_mobile/app/data/services/grafik_services.dart';
import 'package:teraparent_mobile/app/modules/activities/controllers/activities_controller.dart';

class HomeController extends GetxController {

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late final ActivitiesController activitiesController;
  final GrafikService _weeklyProggresStats = Get.find<GrafikService>();
  final ArticleService _articleService = Get.find<ArticleService>();
  
  final isLoading = false.obs;
  final isLoadingArticles = false.obs;
  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final childName = ''.obs;
  final childAgeText = ''.obs;
  
  final todayActivity = <DailyActivityModel>[].obs;
  final weeklyStats = Rxn<WeeklyActivityStatsModel>();
  final articles = <ArticleModel>[].obs;

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

      await setActivityByScreening();
      await fetchHomeArticles();
      
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHomeArticles() async {
    try {
      isLoadingArticles.value = true;
      final response = await _articleService.getAllArticles(page: 1, limit: 3);
      if (response.success && response.data != null) {
        articles.assignAll(response.data!);
      }
    } catch (e) {
      print('Error fetching articles for home: $e');
    } finally {
      isLoadingArticles.value = false;
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