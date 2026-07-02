import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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

    if (args != null && args is Map) {
      sessionId.value = args['sessionId']?.toString() ?? '';

      final rawResult = args['result'];

      if (rawResult is ScreeningResultModel) {
        result.value = rawResult;
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
        return 'Autisme Spectrum';
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
    final value = result.value?.recommendationText;

    if (value == null || value.isEmpty || value == 'null') {
      return 'Belum ada rekomendasi yang tersedia dari hasil screening.';
    }

    return value;
  }

  String get analysisDescription {
    final value = result.value?.resultDescription;

    if (value != null && value.isNotEmpty) {
      return value;
    }

    return '-';
  }

  String get disclaimerText {
    return result.value?.disclaimerText ?? '-';
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

}