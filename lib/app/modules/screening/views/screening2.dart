import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/screening_controller.dart';

class Screening2 extends GetView<ScreeningController> {
  const Screening2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          'Tahap 2: Motorik & Sensorik',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Skrining Anak',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        LinearProgressIndicator(
          value: 0.5,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor:
              const AlwaysStoppedAnimation(
            Color(0xFF2F6F5F),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Kemajuan Skrining 50%',
        ),

        const SizedBox(height: 30),

        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: controller
              .tahap2Questions.length,

          itemBuilder: (context, index) {

            return questionCard(
              number: index + 1,
              question: controller
                  .tahap2Questions[index],
            );
          },
        ),
      ],
    );
  }

  Widget questionCard({
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
        children: [

          CircleAvatar(
            backgroundColor:
                const Color(0xFFAEEACD),

            child: Text(
              number.toString(),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 1.6,
            ),
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
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),

      child: Center(
        child: Text(text),
      ),
    );
  }
}