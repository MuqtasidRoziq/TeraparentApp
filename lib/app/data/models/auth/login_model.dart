import 'package:teraparent_mobile/app/data/models/user_model.dart';

class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponseModel {
  late final UserModel user;
  late final String? token;

  LoginResponseModel({
    required this.user,
    this.token,
  });
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user']),
      ),
      token: json['token']?.toString(),
    ); 
  }
}