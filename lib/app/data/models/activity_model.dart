class DailyActivityModel {
  final String id;
  final String childId;
  final String? screeningSessionId;
  final String? templateId;

  final String title;
  final String domain; // enum ScreeningDomain di backend
  final String? relatedIndication; // enum IndicationType di backend

  final String description;
  final String purpose;
  final int durationMinutes;
  final String difficulty; // EASY | MEDIUM | HARD

  final List<String> toolsNeeded;
  final List<String> steps;
  final String successIndicator;
  final String? parentTips;

  final DateTime scheduledDate;
  final DateTime? reminderAt;
  final String status; 

  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? missedAt;

  DailyActivityModel({
    required this.id,
    required this.childId,
    this.screeningSessionId,
    this.templateId,
    required this.title,
    required this.domain,
    this.relatedIndication,
    required this.description,
    required this.purpose,
    required this.durationMinutes,
    required this.difficulty,
    required this.toolsNeeded,
    required this.steps,
    required this.successIndicator,
    this.parentTips,
    required this.scheduledDate,
    this.reminderAt,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.missedAt,
  });

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      id: json['id']?.toString() ?? '',
      childId: json['childId']?.toString() ?? '',
      screeningSessionId: json['screeningSessionId']?.toString(),
      templateId: json['templateId']?.toString(),
      title: json['title']?.toString() ?? '',
      domain: json['domain']?.toString() ?? '',
      relatedIndication: json['relatedIndication']?.toString(),
      description: json['description']?.toString() ?? '',
      purpose: json['purpose']?.toString() ?? '',
      durationMinutes:
          int.tryParse(json['durationMinutes']?.toString() ?? '0') ?? 0,
      difficulty: json['difficulty']?.toString() ?? 'EASY',
      toolsNeeded: _stringListFrom(json['toolsNeeded']),
      steps: _stringListFrom(json['steps']),
      successIndicator: json['successIndicator']?.toString() ?? '',
      parentTips: json['parentTips']?.toString(),
      scheduledDate:
          DateTime.tryParse(json['scheduledDate']?.toString() ?? '') ??
              DateTime.now(),
      reminderAt: json['reminderAt'] != null
          ? DateTime.tryParse(json['reminderAt'].toString())
          : null,
      status: json['status']?.toString() ?? 'NOT_STARTED',
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : null,
      missedAt: json['missedAt'] != null
          ? DateTime.tryParse(json['missedAt'].toString())
          : null,
    );
  }

  static List<String> _stringListFrom(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isMissed => status.toUpperCase() == 'MISSED';
  bool get isInProgress => status.toUpperCase() == 'IN_PROGRESS';
  bool get isNotStarted => status.toUpperCase() == 'NOT_STARTED';

  /// Label domain dalam Bahasa Indonesia, konsisten dengan modul screening
  /// (lihat result_screening_controller.dart & screening_view.dart).
  String get domainLabel {
    switch (domain.toUpperCase()) {
      case 'COMMUNICATION_SPEECH':
        return 'Komunikasi & Bicara';
      case 'SOCIAL_EMOTIONAL':
        return 'Sosial Emosional';
      case 'COGNITIVE_PROBLEM_SOLVING':
        return 'Kognitif & Pemecahan Masalah';
      case 'PHYSICAL_MOTOR':
        return 'Fisik Motorik';
      default:
        return domain;
    }
  }

  /// Jam terjadwal, contoh: "09:00 WIB"
  String get timeLabel {
    final hour = scheduledDate.hour.toString().padLeft(2, '0');
    final minute = scheduledDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  String get durationLabel => '$durationMinutes Menit';

  DailyActivityModel copyWith({
    String? status,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? missedAt,
  }) {
    return DailyActivityModel(
      id: id,
      childId: childId,
      screeningSessionId: screeningSessionId,
      templateId: templateId,
      title: title,
      domain: domain,
      relatedIndication: relatedIndication,
      description: description,
      purpose: purpose,
      durationMinutes: durationMinutes,
      difficulty: difficulty,
      toolsNeeded: toolsNeeded,
      steps: steps,
      successIndicator: successIndicator,
      parentTips: parentTips,
      scheduledDate: scheduledDate,
      reminderAt: reminderAt,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      missedAt: missedAt ?? this.missedAt,
    );
  }
}

/// Payload catatan orang tua saat menyelesaikan aktivitas.
/// Dikirim opsional bersamaan dengan PATCH status = COMPLETED.
class ActivityNoteRequestModel {
  final String? childResponse;
  final int? successLevel;
  final String? obstacleNote;
  final String? parentNote;

  ActivityNoteRequestModel({
    this.childResponse,
    this.successLevel,
    this.obstacleNote,
    this.parentNote,
  });

  Map<String, dynamic> toJson() {
    return {
      if (childResponse != null) 'childResponse': childResponse,
      if (successLevel != null) 'successLevel': successLevel,
      if (obstacleNote != null) 'obstacleNote': obstacleNote,
      if (parentNote != null) 'parentNote': parentNote,
    };
  }
}
