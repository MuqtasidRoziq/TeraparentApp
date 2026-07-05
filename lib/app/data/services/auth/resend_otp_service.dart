import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/resend_otp_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class ResendOtpService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<void>> resendOtp({
    required ResendOtpRequestModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/resend-otp',
        data: request.toJson(),
      );

      return ApiResponseModel<void>.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (_) {
      throw 'Terjadi kesalahan tidak terduga';
    }
  }

}