import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_log_model.dart';
import 'package:teraparent_mobile/app/data/services/activity_log_service.dart';

class RiwayatController extends GetxController {
  final ActivityLogService _logService = Get.find<ActivityLogService>();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final activityLogs = <ActivityLogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivityLogs();
  }

  Future<void> fetchActivityLogs() async {
    try {
      isLoading(true);
      errorMessage('');

      final result = await _logService.getActivityLogs(limit: 100);

      if (result.success) {
        activityLogs.assignAll(result.data ?? []);
      } else {
        errorMessage.value = result.message.isNotEmpty
            ? result.message
            : 'Gagal mengambil riwayat aktivitas';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  /// Kelompokkan log berdasarkan hari
  List<LogGroup> get groupedLogs {
    final Map<String, List<ActivityLogModel>> grouped = {};
    final now = DateTime.now();

    for (final log in activityLogs) {
      final label = _dateLabel(log.createdAt, now);
      grouped.putIfAbsent(label, () => []).add(log);
    }

    // Urutkan berdasarkan tanggal terbaru
    return grouped.entries
        .map((e) => LogGroup(label: e.key, logs: e.value))
        .toList();
  }

  String _dateLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) return 'Hari Ini';
    if (diff == 1) return 'Kemarin';
    if (diff < 7) return '$diff Hari Lalu';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Total semua log
  int get totalLogs => activityLogs.length;

  /// Jumlah log berdasarkan kategori
  int countByCategory(String category) =>
      activityLogs.where((l) => l.category == category).length;

  /// Ikon berdasarkan kategori log
  IconData iconForCategory(String category) {
    switch (category) {
      case 'activity':
        return Icons.playlist_add_check_rounded;
      case 'screening':
        return Icons.analytics_rounded;
      case 'auth':
        return Icons.login_rounded;
      case 'profile':
        return Icons.person_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  /// Warna berdasarkan kategori log
  Color colorForCategory(String category) {
    switch (category) {
      case 'activity':
        return const Color(0xFF2F7D69);
      case 'screening':
        return const Color(0xFFB06000);
      case 'auth':
        return const Color(0xFF1A73E8);
      case 'profile':
        return const Color(0xFF8B5E1A);
      default:
        return const Color(0xFF607D8B);
    }
  }

  Color bgForCategory(String category) {
    switch (category) {
      case 'activity':
        return const Color(0xFFE6F4EA);
      case 'screening':
        return const Color(0xFFFEF7E0);
      case 'auth':
        return const Color(0xFFE8F0FE);
      case 'profile':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFECEFF1);
    }
  }

  /// Format waktu log: "09:30"
  String timeLabel(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class LogGroup {
  final String label;
  final List<ActivityLogModel> logs;
  const LogGroup({required this.label, required this.logs});
}