import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/grafik_model.dart';

import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class GrafikService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<WeeklyActivityStatsModel>> getActivityStats({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/grafik/activities-stats/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<WeeklyActivityStatsModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => WeeklyActivityStatsModel.fromJson(
          Map<String, dynamic>.from(data),
        ),
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<ScreeningRadarModel>> getLastScreeningStats({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/grafik/last-screening-stats/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<ScreeningRadarModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final radarJson = (data is Map && data['radar'] is Map)
              ? Map<String, dynamic>.from(data['radar'])
              : null;

          return ScreeningRadarModel.fromJson(radarJson);
        },
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<List<ScreeningTrendPointModel>>>
      getScreeningHistoryStats({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/grafik/screening-history-stats/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<ScreeningTrendPointModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList =
              (data is Map && data['trend'] is List) ? data['trend'] : [];

          return rawList
              .map(
                (item) => ScreeningTrendPointModel.fromJson(
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
}
