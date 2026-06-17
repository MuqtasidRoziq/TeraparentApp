class ResendOtpRequestModel {
  final String email;

  ResendOtpRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class ResendOtpResponseModel {
  final String message;

  ResendOtpResponseModel({required this.message});

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }
}