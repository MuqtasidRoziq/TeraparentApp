import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/child_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class ChildCreateService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<ApiResponseModel<ChildResponseModel>> createChild({
    required ChildRequestModel request,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      if ( token == null || token.isEmpty) {
        throw 'Token login tidak ditemukan. Silakan login ulang.';
      }

      final response = await _apiService.dio.post(
        '/api/child/create-child',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return ApiResponseModel<ChildResponseModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => ChildResponseModel.fromJson(
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