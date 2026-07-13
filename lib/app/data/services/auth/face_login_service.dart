import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/login_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/face_login_model.dart'; 
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class FaceAuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<LoginResponseModel>> loginFace(
    FaceAuthRequestModel request,
  ) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/face-login',
        data: request.toJson(),
      );

      return ApiResponseModel<LoginResponseModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => LoginResponseModel.fromJson(
          Map<String, dynamic>.from(data),
        ),
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (_) {
      throw 'Terjadi kesalahan saat login wajah';
    }
  }

  Future<ApiResponseModel<dynamic>> registerFace(
    FaceAuthRequestModel request,
  ) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/register-face',
        data: request.toJson(),
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<dynamic>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => data,
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (_) {
      throw 'Terjadi kesalahan saat mendaftarkan wajah';
    }
  }
}
