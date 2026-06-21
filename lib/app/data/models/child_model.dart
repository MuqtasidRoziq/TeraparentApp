class ChildRequestModel {
  final String name;
  final DateTime birthDate;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String? initialDevelopmentNote;

  ChildRequestModel({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.initialDevelopmentNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'initialDevelopmentNote': initialDevelopmentNote,
    };
  }
}

class ChildModel {
  final int id;
  final int userId;
  final String name;
  final DateTime? birthDate;
  final int? ageYear;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String? initialDevelopmentNote;
  final String? photo;

  ChildModel({
    required this.id,
    required this.userId,
    required this.name,
    this.birthDate,
    this.ageYear,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.initialDevelopmentNote,
    this.photo,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['userId'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      ageYear: json['ageYear'] == null
          ? null
          : int.tryParse(json['ageYear'].toString()),
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