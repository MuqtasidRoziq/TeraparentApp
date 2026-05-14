import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/screening_controller.dart';

class ScreeningView extends GetView<ScreeningController> {
  const ScreeningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          'SCREENING TAHAP 1',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Communication & Speech',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        LinearProgressIndicator(
          value: 0.2,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor:
              const AlwaysStoppedAnimation(
            Color(0xFF2F6F5F),
          ),
        ),

        const SizedBox(height: 8),

        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            '20%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: controller
              .tahap1Questions.length,

          itemBuilder: (context, index) {

            return buildQuestionCard(
              number: index + 1,
              question: controller
                  .tahap1Questions[index],
            );
          },
        ),
      ],
    );
  }

  Widget buildQuestionCard({
    required int number,
    required String question,
  }) {

    return Container(
      margin: const EdgeInsets.only(
          bottom: 20),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFD7F1F6),

                  borderRadius:
                      BorderRadius.circular(
                          10),
                ),

                child: Center(
                  child: Text(
                    number
                        .toString()
                        .padLeft(2, '0'),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          answerButton('Sering'),

          const SizedBox(height: 12),

          answerButton('Kadang-kadang'),

          const SizedBox(height: 12),

          answerButton('Tidak Pernah'),
        ],
      ),
    );
  }

  Widget answerButton(String text) {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
      ),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Center(
        child: Text(text),
      ),
    );
  }
}