import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/screening_controller.dart';

class Screening3 extends GetView<ScreeningController> {
  const Screening3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          'Skrining Anak',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Interaksi Sosial',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 20),

        LinearProgressIndicator(
          value: 0.8,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor:
              const AlwaysStoppedAnimation(
            Color(0xFF2F6F5F),
          ),
        ),

        const SizedBox(height: 30),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFDDF3F5),
            borderRadius:
                BorderRadius.circular(16),
          ),

          child: const Row(
            children: [

              Icon(Icons.info_outline),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Silakan pilih jawaban yang paling menggambarkan perilaku harian anak Anda.',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        Row(
          children: [

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color:
                    const Color(0xFFAEEACD),

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: const Text(
                'Tahap 3',
              ),
            ),

            Expanded(
              child: Divider(
                indent: 10,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: controller
              .tahap3Questions.length,

          itemBuilder: (context, index) {

            return questionCard(
              number: index + 1,
              question: controller
                  .tahap3Questions[index],
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            '$number. $question',
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          radioAnswer('Sering'),

          const SizedBox(height: 12),

          radioAnswer('Kadang-kadang'),

          const SizedBox(height: 12),

          radioAnswer('Tidak Pernah'),
        ],
      ),
    );
  }

  Widget radioAnswer(String text) {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 20,
            height: 20,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Text(text),
        ],
      ),
    );
  }
}