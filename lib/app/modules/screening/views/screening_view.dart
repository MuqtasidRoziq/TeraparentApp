import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/screening_controller.dart';

class ScreeningView extends GetView<ScreeningController> {
  const ScreeningView({super.key});

  static const Color primaryColor = Color(0xFF235A43);
  static const Color backgroundColor = Color(0xFFF4FBF7);
  static const Color cardColor = Colors.white;
  static const Color inputColor = Color(0xFFF1F5F3);

  double responsive(
    double width,
    double value, {
    double min = 0,
    double max = double.infinity,
  }) {
    return (width * value).clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -height * 0.12,
            right: -width * 0.2,
            child: Container(
              width: width * 0.7,
              height: width * 0.7,
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -height * 0.13,
            left: -width * 0.24,
            child: Container(
              width: width * 0.75,
              height: width * 0.75,
              decoration: BoxDecoration(
                color: const Color(0xFFCDEFE4).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                if (controller.questions.isEmpty) {
                  return _emptyQuestionView(width);
                }

                return Column(
                  children: [
                    _header(width),

                    Expanded(
                      child: PageView.builder(
                        controller: controller.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.questions.length,
                        itemBuilder: (context, index) {
                          return _questionPage(
                            width: width,
                            index: index,
                          );
                        },
                      ),
                    ),

                    _bottomButton(width),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(double width) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive(width, 0.06, min: 20, max: 28),
        16,
        responsive(width, 0.06, min: 20, max: 28),
        10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: controller.previousPage,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: responsive(width, 0.12, min: 42, max: 48),
                  height: responsive(width, 0.12, min: 42, max: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Screening Anak',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Obx(
                      () => Text(
                        'Pertanyaan ${controller.currentIndex.value + 1} dari ${controller.totalQuestions}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: controller.progressValue,
                minHeight: 10,
                backgroundColor: const Color(0xFFE0EFE7),
                color: primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Obx(
            () => Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${controller.progressPercentage}%',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionPage({
    required double width,
    required int index,
  }) {
    final question = controller.questions[index];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: responsive(width, 0.06, min: 20, max: 28),
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _domainBadge(question.domain),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              responsive(width, 0.055, min: 20, max: 26),
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              question.question,
              style: TextStyle(
                fontSize: responsive(width, 0.048, min: 18, max: 21),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.45,
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Pilih jawaban',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 14),

          Column(
            children: question.options.map((option) {
              return Obx(
                () {
                  final isSelected =
                      controller.selectedOptionId.value == option.id;

                  return _optionItem(
                    title: option.label,
                    value: option.value,
                    isSelected: isSelected,
                    onTap: () {
                      controller.selectOption(option.id);
                    },
                  );
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _domainBadge(String domain) {
    String label = domain;

    if (domain == 'COMMUNICATION_SPEECH') {
      label = 'Komunikasi & Bicara';
    } else if (domain == 'SOCIAL_EMOTIONAL') {
      label = 'Sosial Emosional';
    } else if (domain == 'COGNITIVE_PROBLEM_SOLVING') {
      label = 'Kognitif';
    } else if (domain == 'PHYSICAL_MOTOR') {
      label = 'Fisik Motorik';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _optionItem({
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xFFE4EAE7),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : inputColor,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: primaryColor,
                      )
                    : null,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        responsive(width, 0.06, min: 20, max: 28),
        12,
        responsive(width, 0.06, min: 20, max: 28),
        20,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.95),
      ),
      child: Obx(
        () {
          final isLast =
              controller.currentIndex.value == controller.questions.length - 1;

          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      isLast ? 'Selesai Screening' : 'Lanjut',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyQuestionView(double width) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive(width, 0.08, min: 24, max: 36),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: responsive(width, 0.16, min: 56, max: 74),
                color: primaryColor,
              ),

              const SizedBox(height: 18),

              const Text(
                'Pertanyaan Tidak Tersedia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Belum ada pertanyaan screening yang dapat ditampilkan untuk data anak ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    controller.initScreening();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}