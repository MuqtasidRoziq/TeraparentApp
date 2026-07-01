import 'package:flutter/material.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';

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
  final String title;
  final String description;
  final String time;
  final String? imageUrl;
  final VoidCallback onStart;

  const DailyActivityCardNone({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.imageUrl,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Batasi lebar card agar proporsional saat dipakai di dalam list/grid
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xffF1F5F9), // Border tipis halus luar
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= AREA GAMBAR & BADGE WAKTU =================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: const Color(0xffA7E0D3),
                        child: const Icon(Icons.image, color: Colors.white, size: 40),
                      )
                    : Image.network(
                        imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // Fallback jika gambar gagal dimuat
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: const Color(0xffA7E0D3),
                          child: const Icon(Icons.image, color: Colors.white, size: 40),
                        ),
                      ),
              ),
              // Badge Waktu (Mengambang di kanan atas gambar)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1E293B),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ================= AREA KONTEN UTAMA =================
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Judul dan Icon Bintang
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.star,
                      color: Color(0xff2E5A5A), // Warna hijau gelap khas Teraparent
                      size: 24,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),

                // Deskripsi Aktivitas
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Mulai Aktivitas (Full Width)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2F6F57), // Hijau pekat sesuai mockup
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  onPressed: onStart,
                  child: const Text(
                    'Mulai Aktivitas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}