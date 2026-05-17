import 'package:flutter/material.dart';
import 'package:teraparent_mobile/app/components/colors.dart';

class DailyActivityCardSuccess extends StatelessWidget {
  final String title;
  final String time;

  const DailyActivityCardSuccess({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              gradient: const LinearGradient(
                colors: [Color(0xffB8EBCF), Color(0xffA8DDE7)],
              ),
            ),

            child: const Icon(
              Icons.toys,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class DailyActivityCardNone extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final String time;
  final VoidCallback onStart;

  const DailyActivityCardNone({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    required this.time,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xffEDF5F2),
        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: const Color(0xffB7CBC6),
          width: 2,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xff2F6F57),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const Icon(Icons.more_vert),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            description,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2F6F57),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),

                onPressed: onStart,

                child: const Text(
                  'Mulai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}