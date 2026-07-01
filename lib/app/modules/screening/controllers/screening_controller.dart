import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teraparent_mobile/app/data/models/screening_model.dart';
import 'package:teraparent_mobile/app/data/services/screening_services.dart';
import '../../../routes/app_pages.dart';

class ScreeningController extends GetxController {
  final PageController pageController = PageController();

  final ScreeningService _screeningService = Get.find<ScreeningService>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final questions = <ScreeningQuestionModel>[].obs;

  final currentIndex = 0.obs;
  final selectedOptionId = RxnString();

  final sessionId = ''.obs;

  final answers = <String, String>{}.obs;

  ScreeningQuestionModel get currentQuestion => questions[currentIndex.value];

  int get totalQuestions => questions.length;

  double get progressValue {
    if (questions.isEmpty) return 0;
    return (currentIndex.value + 1) / questions.length;
  }

  int get progressPercentage {
    if (questions.isEmpty) return 0;
    return ((currentIndex.value + 1) / questions.length * 100).round();
  }

  @override
  void onInit() {
    super.onInit();
    initScreening();
  }

  Future<void> initScreening() async {
    final childId = await _getChildId();

    if (childId == null || childId.isEmpty) {
      Get.snackbar(
        'Error',
        'Data anak belum ditemukan. Silakan isi data anak terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(Routes.CHILD_DATE);
      return;
    }

    try {
      isLoading.value = true;

      currentIndex.value = 0;
      selectedOptionId.value = null;
      sessionId.value = '';
      answers.clear();
      questions.clear();

      final questionsResult = await _screeningService.getQuestions(
        childId: childId,
      );

      if (questionsResult.success && questionsResult.data != null) {
        questions.assignAll(questionsResult.data!);
      } else {
        Get.snackbar(
          'Gagal',
          questionsResult.message.isNotEmpty
              ? questionsResult.message
              : 'Gagal mengambil pertanyaan screening',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (questions.isEmpty) {
        Get.snackbar(
          'Info',
          'Pertanyaan screening belum tersedia',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final startResult = await _screeningService.startScreening(
        childId: childId,
      );

      if (startResult.success && startResult.data != null) {
        sessionId.value = startResult.data!.sessionId;
      } else {
        Get.snackbar(
          'Gagal',
          startResult.message.isNotEmpty
              ? startResult.message
              : 'Gagal memulai screening',
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

  Future<String?> _getChildId() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final childIdString = _prefs.getString('childId');

    if (childIdString != null && childIdString.isNotEmpty) {
      return childIdString;
    }

    final childIdInt = _prefs.getInt('childId');

    if (childIdInt != null) {
      return childIdInt.toString();
    }

    return null;
  }

  void selectOption(String optionId) {
    if (questions.isEmpty) return;

    selectedOptionId.value = optionId;

    final questionId = currentQuestion.id;
    answers[questionId] = optionId;
  }

  Future<void> nextPage() async {
    if (questions.isEmpty) return;

    if (selectedOptionId.value == null) {
      Get.snackbar(
        'Error',
        'Pilih jawaban terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;

      final nextQuestionId = currentQuestion.id;
      selectedOptionId.value = answers[nextQuestionId];

      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      return;
    }

    await submitAnswers();
  }

  void previousPage() {
    if (questions.isEmpty) {
      Get.back();
      return;
    }

    if (currentIndex.value > 0) {
      currentIndex.value--;

      final questionId = currentQuestion.id;
      selectedOptionId.value = answers[questionId];

      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      return;
    }

    Get.back();
  }

  Future<void> submitAnswers() async {
    if (sessionId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'sesi screening tidak valid. Silakan mulai ulang proses screening.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (answers.length != questions.length) {
      Get.snackbar(
        'Error',
        'Masih ada pertanyaan yang belum dijawab',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final request = SubmitScreeningRequestModel(
        answers: answers.entries
            .map(
              (entry) => ScreeningAnswerRequestModel(
                questionId: entry.key,
                optionId: entry.value,
              ),
            )
            .toList(),
      );

      final response = await _screeningService.submitScreening(
        sessionId: sessionId.value,
        request: request,
      );
      
      if (response.success && response.data != null) {
        final screeningResult = response.data!;
        final prefs = await SharedPreferences.getInstance();

        debugPrint('response: ${screeningResult}');

        await prefs.setString('mainIndication', screeningResult.mainIndication);
        await prefs.setInt('finalScore', screeningResult.finalScore);
        await prefs.setString('priorityDomain', screeningResult.priorityDomain);
        await prefs.setString('recommendation', screeningResult.recommendationText);
        await prefs.setString('riskCategory', screeningResult.riskCategory);

        Get.offAllNamed(
          Routes.RESULT_SCREENING,
          arguments: {
            'sessionId': sessionId.value,
            'result': screeningResult,
          },
        );
      } else {
        Get.snackbar(
          'Gagal',
          response.message.isNotEmpty
              ? response.message
              : 'Gagal mengirim hasil screening',
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
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}