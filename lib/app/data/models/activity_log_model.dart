class ActivityLogModel {
  final String id;
  final String userId;
  final String? childId;
  final String action;
  final String? description;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.userId,
    this.childId,
    required this.action,
    this.description,
    this.entityType,
    this.entityId,
    this.metadata,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      childId: json['childId']?.toString(),
      action: json['action']?.toString() ?? '',
      description: json['description']?.toString(),
      entityType: json['entityType']?.toString(),
      entityId: json['entityId']?.toString(),
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Label tampilan aksi
  String get actionLabel {
    switch (action.toUpperCase()) {
      case 'ACTIVITY_COMPLETED':
        return 'Aktivitas Selesai';
      case 'ACTIVITY_STARTED':
        return 'Aktivitas Dimulai';
      case 'ACTIVITY_MISSED':
        return 'Aktivitas Terlewat';
      case 'SCREENING_SUBMITTED':
        return 'Skrining Dikirim';
      case 'SCREENING_COMPLETED':
        return 'Skrining Selesai';
      case 'LOGIN':
        return 'Login';
      case 'LOGOUT':
        return 'Logout';
      case 'PROFILE_UPDATED':
        return 'Profil Diperbarui';
      case 'CHILD_REGISTERED':
        return 'Data Anak Didaftarkan';
      default:
        final parts = action.replaceAll('_', ' ').toLowerCase().split(' ');
        return parts.map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
    }
  }

  /// Kategori log untuk pengelompokan ikon
  String get category {
    final upper = action.toUpperCase();
    if (upper.contains('ACTIVITY')) return 'activity';
    if (upper.contains('SCREENING')) return 'screening';
    if (upper.contains('LOGIN') || upper.contains('LOGOUT')) return 'auth';
    if (upper.contains('PROFILE') || upper.contains('CHILD')) return 'profile';
    return 'other';
  }
}


