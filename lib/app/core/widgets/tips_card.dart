import 'package:flutter/material.dart';

class TipsCard extends StatelessWidget {
  final String text;

  const TipsCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFA7E0D3), // Warna hijau toska pastel seperti mockup
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TIPS SCREENING",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1F4E45), letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2C6B5E), height: 1.4, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Sisi kanan meniru boks gambar ilustrasi planet di mockup
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A), // Latar gelap ilustrasi
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.orangeAccent, size: 30), // Pengganti asset gambar planet
          )
        ],
      ),
    );
  }
}