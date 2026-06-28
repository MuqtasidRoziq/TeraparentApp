import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;

  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final childName = ''.obs;
  final childAgeText = ''.obs;

  final mainIndication = ''.obs;
  final riskCategory = ''.obs;
  final priorityDomain = ''.obs;

  final activityTitle = 'Meniru Suara Hewan'.obs;
  final activityDuration = '10 menit'.obs;
  final activityDescription =
      'Melatih kemampuan komunikasi dan respons anak melalui permainan suara hewan.'
          .obs;

  final weeklyProgress = <WeeklyProgressItem>[
    WeeklyProgressItem(day: 'SEN', value: 1),
    WeeklyProgressItem(day: 'SEL', value: 1),
    WeeklyProgressItem(day: 'RAB', value: 1),
    WeeklyProgressItem(day: 'KAM', value: 1),
    WeeklyProgressItem(day: 'JUM', value: 0),
    WeeklyProgressItem(day: 'SAB', value: 0),
    WeeklyProgressItem(day: 'MIN', value: 0),
  ].obs;

  @override
  void onInit() {
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
      final indication = prefs.getString('mainIndication') ?? 'Belum ada hasil screening';
      mainIndication.value = formatMainIndication(indication);
      riskCategory.value = prefs.getString('riskCategory') ?? 'Belum ada hasil screening';
      priorityDomain.value = prefs.getString('priorityDomain') ?? '-';
      final birthDateString = prefs.getString('birthDate');

      if (birthDateString != null && birthDateString.isNotEmpty) {
        final birthDate = DateTime.tryParse(birthDateString);

        if (birthDate != null) {
          childAgeText.value = calculateAgeText(birthDate);
        } else {
          childAgeText.value = '-';
        }
      } else {
        childAgeText.value = '-';
      }

      setActivityByScreening();
    } finally {
      isLoading.value = false;
    }
  }

  void setActivityByScreening() {
    final indication = mainIndication.value.toUpperCase();
    final domain = priorityDomain.value.toUpperCase();

    if (indication.contains('SPEECH') ||
        domain.contains('COMMUNICATION') ||
        domain.contains('BICARA')) {
      activityTitle.value = 'Meniru Suara Hewan';
      activityDuration.value = '10 menit';
      activityDescription.value =
          'Melatih kemampuan komunikasi dan respons anak melalui permainan suara hewan.';
      return;
    }

    if (indication.contains('AUTISM') ||
        domain.contains('SOCIAL') ||
        domain.contains('SOSIAL')) {
      activityTitle.value = 'Bermain Giliran';
      activityDuration.value = '10 menit';
      activityDescription.value =
          'Melatih interaksi sosial anak melalui aktivitas sederhana secara bergantian.';
      return;
    }

    if (indication.contains('ADHD') ||
        domain.contains('COGNITIVE') ||
        domain.contains('KOGNITIF')) {
      activityTitle.value = 'Menyusun Puzzle Sederhana';
      activityDuration.value = '15 menit';
      activityDescription.value =
          'Melatih fokus, konsentrasi, dan kemampuan memecahkan masalah sederhana.';
      return;
    }

    if (domain.contains('PHYSICAL') ||
        domain.contains('MOTOR')) {
      activityTitle.value = 'Lempar Tangkap Bola';
      activityDuration.value = '10 menit';
      activityDescription.value =
          'Melatih koordinasi tangan, mata, dan kemampuan motorik anak.';
      return;
    }

    activityTitle.value = 'Stimulasi Harian Anak';
    activityDuration.value = '10 menit';
    activityDescription.value =
        'Lakukan stimulasi sederhana sesuai kebutuhan perkembangan anak di rumah.';
  }

  String get firstName {
    if (userName.value.trim().isEmpty) {
      return 'Bunda';
    }

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

  int get completedActivityCount {
    return weeklyProgress.where((item) => item.value > 0).length;
  }

  int get weeklyTarget {
    return 7;
  }

  String get weeklyProgressText {
    return '$completedActivityCount dari $weeklyTarget aktivitas selesai minggu ini';
  }

  double barHeight(int value) {
    if (value <= 0) {
      return 30;
    }

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

  String calculateAgeText(DateTime birthDate) {
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (now.day < birthDate.day) {
      months--;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    if (years <= 0) {
      if (months <= 0) {
        return '0 Bulan';
      }

      return '$months Bulan';
    }

    if (months == 0) {
      return '$years Tahun';
    }

    return '$years Tahun $months Bulan';
  }
}

class WeeklyProgressItem {
  final String day;
  final int value;

  WeeklyProgressItem({
    required this.day,
    required this.value,
  });
}