import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/reset_password_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class ResetPasswordService{
  final _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<ResetPasswordModel>> resetPassword({
    required ResetPasswordModel resetPasswordModel,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/reset-password',
        data: resetPasswordModel.toJson(),
      );

      return ApiResponseModel<ResetPasswordModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => ResetPasswordModel.fromJson(
          Map<String, dynamic>.from(data),
        )
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<RequestResetPasswordModel>> requestReset({
    required RequestResetPasswordModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/auth/request-reset-password',
        data: request.toJson(),
      );

      return ApiResponseModel<RequestResetPasswordModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => RequestResetPasswordModel.fromJson(
          Map<String, dynamic>.from(data),
        ),
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
