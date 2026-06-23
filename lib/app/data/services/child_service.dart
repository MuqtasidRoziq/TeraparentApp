import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/auth/api_response_model.dart';
import 'package:teraparent_mobile/app/data/models/child_model.dart';
import 'package:teraparent_mobile/app/data/services/api_service.dart';

class ChildService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<ChildResponseModel>> createChild({
    required ChildRequestModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/child/create-child',
        data: request.toJson(),
        options: await _apiService.authOptions(),
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

  Future<ApiResponseModel<ChildResponseModel>> getMyChildren() async {
    try {
      final response = await _apiService.dio.get(
        '/api/child/my-children',
        options: await _apiService.authOptions(),
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

  Future<ApiResponseModel<ChildResponseModel>> getChildById({
    required String id,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/child/$id',
        options: await _apiService.authOptions(),
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