import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/activity_log_model.dart';
import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class ActivityLogService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<List<ActivityLogModel>>> getActivityLogs({
    int page = 1,
    int limit = 50,
    String? action,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/users/activity-logs',
        queryParameters: {'page': page, 'limit': limit, 'action': action}
          ..removeWhere((_, v) => v == null),
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<ActivityLogModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;

          if (data is List) {
            rawList = data;
          } else if (data is Map && data['logs'] is List) {
            rawList = data['logs'];
          } else if (data is Map && data['data'] is List) {
            rawList = data['data'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) =>
                    ActivityLogModel.fromJson(Map<String, dynamic>.from(item)),
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
