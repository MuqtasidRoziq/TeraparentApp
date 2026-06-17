import '../user_model.dart';

class VerifyOtpRequestModel {
  final String email;
  final String otp;

  VerifyOtpRequestModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

class VerifyOtpResponseModel {
  final String token;
  final UserModel user;

  VerifyOtpResponseModel({
    required this.token,
    required this.user,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      token: json['token']?.toString() ?? '',
      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user']),
      ),
    );
  }
}