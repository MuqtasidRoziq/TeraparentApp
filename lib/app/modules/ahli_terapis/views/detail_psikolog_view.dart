import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/core/widgets/shimmer_loading.dart';
import 'package:teraparent_mobile/app/modules/ahli_terapis/controllers/detail_psikolog_controller.dart';

class DetailPsikologView extends StatelessWidget {
  final String psikologId;

  const DetailPsikologView({super.key, required this.psikologId});

  @override
  Widget build(BuildContext context) {
    // Put controller with unique tag for this psychologist
    final controller = Get.put(
      DetailPsikologController(psikologId),
      tag: psikologId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A), size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          "Detail Terapis / Psikolog",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // ─── LOADING: Shimmer skeleton ───────────────────────────────
        if (controller.isLoading.value) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header skeleton
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerBox(
                              height: 96,
                              width: 96,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  ShimmerBox(height: 20, width: 60),
                                  SizedBox(height: 10),
                                  ShimmerBox(height: 20, width: 160),
                                  SizedBox(height: 8),
                                  ShimmerBox(height: 16, width: 120),
                                  SizedBox(height: 10),
                                  ShimmerBox(height: 14, width: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const ShimmerBox(height: 1),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            ShimmerBox(height: 50, width: 70),
                            ShimmerBox(height: 50, width: 70),
                            ShimmerBox(height: 50, width: 70),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bio skeleton
                  const ShimmerBox(height: 18, width: 140),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(height: 14),
                        SizedBox(height: 8),
                        ShimmerBox(height: 14),
                        SizedBox(height: 8),
                        ShimmerBox(height: 14, width: 200),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Lokasi skeleton
                  const ShimmerBox(height: 18, width: 180),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(height: 14, width: 140),
                        SizedBox(height: 8),
                        ShimmerBox(height: 14),
                        SizedBox(height: 8),
                        ShimmerBox(height: 14, width: 180),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tags skeleton
                  const ShimmerBox(height: 18, width: 120),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      4,
                      (_) => const ShimmerBox(
                        height: 30,
                        width: 80,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ─── ERROR STATE ─────────────────────────────────────────────
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.fetchDetail(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5A5A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            ),
          );
        }

        // ─── DATA LOADED ─────────────────────────────────────────────
        final p = controller.psikolog.value;
        if (p == null) {
          return const Center(child: Text("Terapis tidak ditemukan."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header Card — foto statis, teks dinamis dari backend
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto — komponen statis
                        Hero(
                          tag: 'psychologist_photo_${p.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              p.photo ?? '',
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, _e) {
                                return Container(
                                  width: 96,
                                  height: 96,
                                  color: const Color(0xFFE6F4F1),
                                  child: const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Color(0xFF2E5A5A),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Teks — data dari backend
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F4F1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  p.type == 'PSYCHOLOGIST'
                                      ? "Psikolog"
                                      : p.type == 'PSYCHIATRIST'
                                          ? "Psikiater"
                                          : "Terapis",
                                  style: const TextStyle(
                                    color: Color(0xFF2E5A5A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.specialization,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2E5A5A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF64748B),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      p.city ?? "Lokasi tidak ditentukan",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Color(0xFFF1F5F9)),
                    // Stats Row — data dari backend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          Icons.star_rounded,
                          const Color(0xFFFFB300),
                          p.rating.toString(),
                          "Rating",
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          Icons.work_outline,
                          const Color(0xFF2E5A5A),
                          p.experience ?? "-",
                          "Pengalaman",
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          Icons.verified_user_outlined,
                          const Color(0xFF0EA5E9),
                          p.isActive ? "Aktif" : "Cuti",
                          "Status",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Bio Section — data dari backend
              const Text(
                "Tentang Terapis",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  p.bio ?? "Tidak ada deskripsi biografi untuk terapis ini.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Lokasi Praktik — data dari backend
              const Text(
                "Detail Lokasi Praktik",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      color: Color(0xFF2E5A5A),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Klinik / Rumah Sakit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.practiceAddress ?? "Lokasi praktik terperinci belum diatur.",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Kategori Fokus — data dari backend
              if (p.focusCategories.isNotEmpty) ...[
                const Text(
                  "Kategori Fokus",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.focusCategories.map((cat) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        cat,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // 5. Jenis Layanan — data dari backend
              if (p.serviceTypes.isNotEmpty) ...[
                const Text(
                  "Jenis Layanan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.serviceTypes.map((serv) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFBAE6FD)),
                      ),
                      child: Text(
                        serv,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0369A1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ],

              // Padding bawah jika tidak ada layanan
              if (p.serviceTypes.isEmpty) const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 32,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }
}
