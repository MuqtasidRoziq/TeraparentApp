class ChildRequestModel {
  final String childName;
  final DateTime birthDate;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String? initialDevelopmentNote;

  ChildRequestModel({
    required this.childName,
    required this.birthDate,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.initialDevelopmentNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': childName,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'initialDevelopmentNote': initialDevelopmentNote,
    };
  }
}

class ChildModel {
  final String id;
  final int userId;
  final String childName;
  final DateTime? birthDate;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String? initialDevelopmentNote;
  final String? photo;

  ChildModel({
    required this.id,
    required this.userId,
    required this.childName,
    required this.birthDate,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.initialDevelopmentNote,
    this.photo,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id']?.toString() ?? '',
      userId: int.tryParse(json['userId'].toString()) ?? 0,
      childName: json['name']?.toString() ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      gender: json['gender']?.toString() ?? '',
      heightCm: double.tryParse(json['heightCm'].toString()) ?? 0,
      weightKg: double.tryParse(json['weightKg'].toString()) ?? 0,
      initialDevelopmentNote: json['initialDevelopmentNote']?.toString(),
      photo: json['photo']?.toString(),
    );
  }
}

class ChildResponseModel {
  final ChildModel child;

  ChildResponseModel({
    required this.child,
  });

  factory ChildResponseModel.fromJson(Map<String, dynamic> json) {
    return ChildResponseModel(
      child: ChildModel.fromJson(json),
    );
  }
}