import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/auth/verify_otp_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class VerifyOtpService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<VerifyOtpResponseModel>> verifyOtp({
    required VerifyOtpRequestModel request,
  }) async {
    try {

      final response = await _apiService.dio.post(
        '/api/auth/verify-otp',
        data: request.toJson(),
      );

      return ApiResponseModel<VerifyOtpResponseModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => VerifyOtpResponseModel.fromJson(
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