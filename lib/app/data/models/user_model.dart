class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isFaceRecognitionActive;
  final bool hasChildData;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.isEmailVerified,
    required this.isFaceRecognitionActive,
    required this.hasChildData,
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
    );
  }
}