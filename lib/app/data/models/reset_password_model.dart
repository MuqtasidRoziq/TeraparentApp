class ResetPasswordModel {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordModel({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      email: json['email'] ?? '',
      otp: json['otp'] ?? '',
      newPassword: json['newPassword'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }
}

class RequestResetPasswordModel {
  final String email;

  RequestResetPasswordModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory RequestResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return RequestResetPasswordModel(
      email: json['email'] ?? '',
    );
  }
}
