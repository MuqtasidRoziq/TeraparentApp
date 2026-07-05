import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_model.dart';
import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class ActivityService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<List<DailyActivityModel>>> getTodayActivities({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/activities/today/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<DailyActivityModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;

          if (data is List) {
            rawList = data;
          } else if (data is Map && data['activities'] is List) {
            rawList = data['activities'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => DailyActivityModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        },
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<List<DailyActivityModel>>> getActivityHistory({
    required String childId,
    String? status,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/activities/history/$childId',
        queryParameters: {
          if (status != null) 'status': status,
        },
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<DailyActivityModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;

          if (data is List) {
            rawList = data;
          } else if (data is Map && data['activities'] is List) {
            rawList = data['activities'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => DailyActivityModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        },
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<DailyActivityModel>> updateActivityStatus({
    required String activityId,
    required String status,
    ActivityNoteRequestModel? note,
  }) async {
    try {
      final response = await _apiService.dio.patch(
        '/api/activities/$activityId/status',
        data: {
          'status': status,
          ...?note?.toJson(),
        },
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<DailyActivityModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => DailyActivityModel.fromJson(
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
