import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/register%20model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class RegisterService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<RegisterResponseModel>> register({
    required RegisterRequestModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );

      return ApiResponseModel<RegisterResponseModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => RegisterResponseModel.fromJson(
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