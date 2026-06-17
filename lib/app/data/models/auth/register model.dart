import 'package:teraparent_mobile/app/data/models/user_model.dart';

class RegisterRequestModel {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;

  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
    };
  }
}

class RegisterResponseModel {
  final UserModel user;
  final String? devOtp;

  RegisterResponseModel({
    required this.user,
    this.devOtp,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user']),
      ),
      devOtp: json['devOtp']?.toString(),
    );
  }
}