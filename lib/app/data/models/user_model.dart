import 'package:teraparent_mobile/app/data/models/child_model.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isFaceRecognitionActive;
  final bool hasChildData;
  final List<ChildModel> children;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.isEmailVerified,
    required this.isFaceRecognitionActive,
    required this.hasChildData,
    required this.children
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      profileImage: json['profileImage']?.toString(),
      isEmailVerified: json['isEmailVerified'] == true,
      isFaceRecognitionActive: json['isFaceRecognitionActive'] == true,
      hasChildData: json['hasChildData'] == true, 
            children: json['children'] == null
          ? []
          : List<ChildModel>.from(
              (json['children'] as List).map(
                (item) => ChildModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              ),
            ),
    );
  }
}