import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/screening_model.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';

class ResultScreeningController extends GetxController {
  final ScreeningService _screeningService = Get.find<ScreeningService>();

  final isLoading = false.obs;
  final result = Rxn<ScreeningResultModel>();
  final sessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadResult();
  }

  Future<void> loadResult() async {
    final args = Get.arguments;

    print('RESULT SCREENING ARGUMENTS: $args');

    if (args != null && args is Map) {
      sessionId.value = args['sessionId']?.toString() ?? '';

      final rawResult = args['result'];

      print('RAW RESULT FROM ARGUMENTS: $rawResult');

      if (rawResult is ScreeningResultModel) {
        result.value = rawResult;
        print('RESULT SET FROM MODEL: ${result.value}');
        return;
      }

      if (rawResult is Map) {
        result.value = ScreeningResultModel.fromJson(
          Map<String, dynamic>.from(rawResult),
        );
        print('RESULT SET FROM MAP: ${result.value}');
        return;
      }
    }

    if (sessionId.value.isNotEmpty) {
      await fetchResultFromApi();
      return;
    }

    await loadResultFromStorage();
  }

  Future<void> fetchResultFromApi() async {
    try {
      isLoading.value = true;

      final response = await _screeningService.getResult(
        sessionId: sessionId.value,
      );

      if (response.success && response.data != null) {
        result.value = response.data;
      } else {
        Get.snackbar(
          'Gagal',
          response.message.isNotEmpty
              ? response.message
              : 'Gagal mengambil hasil screening',
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
      isLoading.value = false;
    }
  }

  Future<void> loadResultFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final riskCategory = prefs.getString('riskCategory');
    final finalScore = prefs.getInt('finalScore');
    final mainIndication = prefs.getString('mainIndication');
    final priorityDomain = prefs.getString('priorityDomain');
    final recommendation = prefs.getString('recommendation');

    if (riskCategory == null || finalScore == null) {
      return;
    }

    result.value = ScreeningResultModel(
      riskCategory: riskCategory,
      finalScore: finalScore,
      mainIndication: mainIndication,
      priorityDomain: priorityDomain,
      recommendation: recommendation,
    );
  }

  String get riskCategory {
    return result.value?.riskCategory ?? '-';
  }

  int get finalScore {
    return result.value?.finalScore ?? 0;
  }

  String get scorePercent {
    return '$finalScore%';
  }

  double get scoreProgress {
    final value = finalScore / 100;

    if (value < 0) return 0;
    if (value > 1) return 1;

    return value;
  }

  String get mainIndicationText {
    final value = result.value?.mainIndication;

    if (value == null || value.isEmpty || value == 'null') {
      return 'Tidak Ada Indikasi Utama';
    }

    switch (value) {
      case 'SPEECH_DELAY':
        return 'Speech Delay';
      case 'AUTISM':
        return 'Autism Spectrum';
      case 'ADHD':
        return 'ADHD';
      case 'DEVELOPMENT_CONCERN':
        return 'Perhatian Perkembangan';
      default:
        return value;
    }
  }

  String get priorityDomainText {
    final value = result.value?.priorityDomain;

    if (value == null || value.isEmpty || value == 'null') {
      return 'Domain belum tersedia';
    }

    switch (value) {
      case 'COMMUNICATION_SPEECH':
        return 'Komunikasi & Bicara';
      case 'SOCIAL_EMOTIONAL':
        return 'Sosial Emosional';
      case 'COGNITIVE_PROBLEM_SOLVING':
        return 'Kognitif & Pemecahan Masalah';
      case 'PHYSICAL_MOTOR':
        return 'Fisik Motorik';
      default:
        return value;
    }
  }

  String get recommendationText {
    final value = result.value?.recommendation;

    if (value == null || value.isEmpty || value == 'null') {
      return 'Belum ada rekomendasi yang tersedia dari hasil screening.';
    }

    return value;
  }

  String get analysisDescription {
    if (finalScore <= 40) {
      return 'Berdasarkan hasil screening, perkembangan Ananda berada pada kategori risiko rendah. Tetap lakukan stimulasi perkembangan secara rutin di rumah.';
    }

    if (finalScore <= 70) {
      return 'Berdasarkan hasil screening, Ananda menunjukkan beberapa area perkembangan yang perlu diperhatikan, terutama pada domain $priorityDomainText.';
    }

    return 'Berdasarkan hasil screening, Ananda menunjukkan indikasi yang cukup tinggi pada domain $priorityDomainText. Disarankan untuk melakukan konsultasi lebih lanjut dengan tenaga profesional.';
  }

  String get lastScreeningText {
    final now = DateTime.now();

    final day = now.day.toString().padLeft(2, '0');
    final month = _monthName(now.month);
    final year = now.year.toString();

    return 'SCREENING TERAKHIR: $day $month $year';
  }

  String _monthName(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MEI';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AGU';
      case 9:
        return 'SEP';
      case 10:
        return 'OKT';
      case 11:
        return 'NOV';
      case 12:
        return 'DES';
      default:
        return '';
    }
  }

  List<String> get chips {
    return [
      '#${priorityDomainText.replaceAll(' ', '')}',
      '#${riskCategory.replaceAll(' ', '')}',
    ];
  }

  List<String> get therapyMethods {
    final indication = result.value?.mainIndication;
    final domain = result.value?.priorityDomain;

    if (indication == 'SPEECH_DELAY' || domain == 'COMMUNICATION_SPEECH') {
      return ['Terapi Wicara', 'Stimulasi Bahasa'];
    }

    if (indication == 'AUTISM' || domain == 'SOCIAL_EMOTIONAL') {
      return ['Terapi Bermain', 'Terapi Perilaku'];
    }

    if (indication == 'ADHD' || domain == 'COGNITIVE_PROBLEM_SOLVING') {
      return ['Latihan Fokus', 'Terapi Okupasi'];
    }

    if (domain == 'PHYSICAL_MOTOR') {
      return ['Latihan Motorik', 'Terapi Okupasi'];
    }

    return ['Stimulasi Harian', 'Terapi Bermain'];
  }
}