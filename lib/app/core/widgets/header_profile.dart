import 'package:flutter/material.dart';
import 'package:teraparent_mobile/app/core/theme/colors.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';

/// Widget header yang konsisten digunakan di semua halaman utama.
/// Menampilkan logo "Teraparent" di kiri dan tombol notifikasi di kanan.
class AppHeader extends StatelessWidget {
  final List<DailyActivityModel>? todayActivities;

  const AppHeader({super.key, this.todayActivities});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo / Brand
        Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Teraparent',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Tombol Notifikasi
        _NotificationButton(todayActivities: todayActivities),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final List<DailyActivityModel>? todayActivities;
  const _NotificationButton({this.todayActivities});

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        todayActivities?.where((a) => !a.isCompleted).length ?? 0;
    final totalCount = todayActivities?.length ?? 0;
    // Badge muncul jika ada aktivitas tertunda
    final hasBadge = pendingCount > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _showNotificationSheet(context, pendingCount, totalCount),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffE6EFEA), width: 1.5),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ),

        // Badge merah
        if (hasBadge)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                pendingCount > 9 ? '9+' : '$pendingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationSheet(
      BuildContext context, int pendingCount, int totalCount) {
    final activities = todayActivities ?? [];
    final pending = activities.where((a) => !a.isCompleted).toList();
    final completed = activities.where((a) => a.isCompleted).toList();
    final now = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header notifikasi
              Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pusat Notifikasi',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(now),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pendingCount > 0 ? '$pendingCount Baru' : 'Semua Baca',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Konten scroll
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    // ── Aktivitas Hari Ini ──────────────────────────────
                    _buildSectionHeader(
                      icon: Icons.today_rounded,
                      label: 'Aktivitas Hari Ini',
                      badge: activities.isEmpty
                          ? null
                          : '${completed.length}/${activities.length} selesai',
                    ),
                    const SizedBox(height: 10),

                    if (activities.isEmpty)
                      _buildInfoCard(
                        icon: Icons.event_available_rounded,
                        iconColor: Colors.grey.shade400,
                        bgColor: Colors.white,
                        title: 'Tidak Ada Aktivitas',
                        subtitle:
                            'Belum ada aktivitas terjadwal hari ini. Cek menu Aktivitas untuk latihan tersedia.',
                      )
                    else ...[
                      // Status progress
                      _buildProgressCard(
                          completed.length, activities.length),
                      const SizedBox(height: 10),

                      // Aktivitas tertunda
                      if (pending.isNotEmpty) ...[
                        _sectionLabel('⏳  Perlu Diselesaikan',
                            Colors.orange.shade700),
                        ...pending
                            .take(3)
                            .map((a) => _activityTile(a, false)),
                        if (pending.length > 3)
                          _buildMoreButton(
                              '${pending.length - 3} aktivitas lainnya'),
                      ],

                      // Aktivitas selesai
                      if (completed.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _sectionLabel('✅  Sudah Selesai', AppColors.primary),
                        ...completed
                            .take(2)
                            .map((a) => _activityTile(a, true)),
                        if (completed.length > 2)
                          _buildMoreButton(
                              '${completed.length - 2} lainnya selesai'),
                      ],
                    ],

                    const SizedBox(height: 20),

                    // ── Pengingat & Tips ────────────────────────────────
                    _buildSectionHeader(
                      icon: Icons.lightbulb_rounded,
                      label: 'Tips & Pengingat',
                    ),
                    const SizedBox(height: 10),

                    _buildTipsCard(),

                    const SizedBox(height: 20),

                    // ── Info Aplikasi ───────────────────────────────────
                    _buildSectionHeader(
                      icon: Icons.info_outline_rounded,
                      label: 'Info Teraparent',
                    ),
                    const SizedBox(height: 10),

                    _buildInfoCard(
                      icon: Icons.update_rounded,
                      iconColor: const Color(0xFF1A73E8),
                      bgColor: const Color(0xFFE8F0FE),
                      title: 'Pantau Terus Perkembangan',
                      subtitle:
                          'Konsistensi adalah kunci. Lakukan aktivitas rutin setiap hari untuk hasil terbaik bagi buah hati Anda.',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.medical_services_rounded,
                      iconColor: const Color(0xFF2F7D69),
                      bgColor: const Color(0xFFE6F4EA),
                      title: 'Konsultasi Terapis',
                      subtitle:
                          'Jika ada perkembangan atau kekhawatiran baru, jangan ragu menghubungi terapis melalui menu Konsultasi.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers UI ────────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String label,
    String? badge,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressCard(int done, int total) {
    final percent = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Hari Ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '$done dari $total selesai',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: done == total && total > 0
                  ? AppColors.primary
                  : Colors.orange.shade400,
            ),
          ),
          if (done == total && total > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.celebration_rounded,
                    size: 15, color: AppColors.primary),
                const SizedBox(width: 5),
                const Text(
                  'Luar biasa! Semua aktivitas hari ini selesai 🎉',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    final tips = [
      _TipItem(
        icon: Icons.access_time_rounded,
        color: const Color(0xFFB06000),
        bg: const Color(0xFFFEF7E0),
        text: 'Lakukan aktivitas di waktu yang sama setiap hari agar anak lebih mudah beradaptasi.',
      ),
      _TipItem(
        icon: Icons.emoji_emotions_rounded,
        color: const Color(0xFF1A73E8),
        bg: const Color(0xFFE8F0FE),
        text: 'Berikan pujian dan afirmasi positif setiap kali anak berhasil menyelesaikan latihan.',
      ),
      _TipItem(
        icon: Icons.self_improvement_rounded,
        color: const Color(0xFF2F7D69),
        bg: const Color(0xFFE6F4EA),
        text: 'Jika anak kelelahan atau menolak, istirahat sejenak dan coba kembali dengan pendekatan yang menyenangkan.',
      ),
    ];

    return Column(
      children: tips.map((tip) => _buildTipTile(tip)).toList(),
    );
  }

  Widget _buildTipTile(_TipItem tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: tip.bg,
              shape: BoxShape.circle,
            ),
            child: Icon(tip.icon, color: tip.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip.text,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: iconColor.withValues(alpha: 0.75),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _activityTile(DailyActivityModel activity, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.orange.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.softGreen
                  : Colors.orange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isCompleted ? AppColors.primary : Colors.orange.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.timeLabel}  ·  ${activity.domainLabel}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activity.durationLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color:
                    isCompleted ? AppColors.primary : Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Text(
          '+ $label',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

class _TipItem {
  final IconData icon;
  final Color color;
  final Color bg;
  final String text;
  const _TipItem({
    required this.icon,
    required this.color,
    required this.bg,
    required this.text,
  });
}

/// Fungsi helper untuk backward compatibility — gunakan [AppHeader].
Widget headerProfile({List<DailyActivityModel>? todayActivities}) {
  return AppHeader(todayActivities: todayActivities);
}
