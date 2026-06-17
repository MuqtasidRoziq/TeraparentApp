import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/login_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class LoginService extends GetxService {
   final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<LoginResponseModel>> login({
    required LoginRequestModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/login',
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
      throw 'Terjadi kesalahan tidak terduga';
    }
  }
}

      // return ApiResponseModel<LoginResponseModel>.fromJson(
      //   Map<String, dynamic>.from(response.data),
      //   fromData: (data) => LoginResponseModel.fromJson(
      //     Map<String, dynamic>.from(data),
      //   ),
      // );