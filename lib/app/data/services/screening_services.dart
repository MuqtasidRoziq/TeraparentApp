import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/screening_model.dart';

import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class ScreeningService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<List<ScreeningQuestionModel>>> getQuestions({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/screening/questions/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<ScreeningQuestionModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;

          if (data is List) {
            rawList = data;
          } else if (data is Map && data['questions'] is List) {
            rawList = data['questions'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => ScreeningQuestionModel.fromJson(
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

  Future<ApiResponseModel<StartScreeningModel>> startScreening({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/screening/start/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<StartScreeningModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => StartScreeningModel.fromJson(
          Map<String, dynamic>.from(data),
        ),
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<ScreeningResultModel>> submitScreening({
    required String sessionId,
    required SubmitScreeningRequestModel request,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/screening/submit/$sessionId',
        data: request.toJson(),
        options: await _apiService.authOptions(),
      );

      print('RAW SUBMIT SCREENING RESPONSE: ${response.data}');

      return ApiResponseModel<ScreeningResultModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          print('RAW SUBMIT SCREENING DATA: $data');

          dynamic resultData = data;

          if (data is Map && data['result'] is Map) {
            resultData = data['result'];
          } else if (data is Map && data['screeningResult'] is Map) {
            resultData = data['screeningResult'];
          } else if (data is Map && data['session'] is Map) {
            resultData = data['session'];
          } else if (data is Map && data['screeningSession'] is Map) {
            resultData = data['screeningSession'];
          } else if (data is Map && data['screening'] is Map) {
            resultData = data['screening'];
          } else if (data is Map && data['recomendationActivity'] is List) {
            resultData = data['recomendationActivity'];
          }

          final result = ScreeningResultModel.fromJson(
            Map<String, dynamic>.from(resultData),
          );

          print('PARSED SUBMIT RESULT: $result');

          return result;
        },
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<ScreeningResultModel>> getResult({
    required String sessionId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/screening/result/$sessionId',
        options: await _apiService.authOptions(),
      );

      print('RAW GET RESULT RESPONSE: ${response.data}');

      return ApiResponseModel<ScreeningResultModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          print('RAW GET RESULT DATA: $data');

          dynamic resultData = data;

          if (data is Map && data['result'] is Map) {
            resultData = data['result'];
            if (data['dailyActivities'] is List) {
              resultData['dailyActivities'] = data['dailyActivities'];
            }
          } else if (data is Map && data['screeningResult'] is Map) {
            resultData = data['screeningResult'];
          } else if (data is Map && data['session'] is Map) {
            resultData = data['session'];
          } else if (data is Map && data['screeningSession'] is Map) {
            resultData = data['screeningSession'];
          } else if (data is Map && data['screening'] is Map) {
            resultData = data['screening'];
          }

          
          final result = ScreeningResultModel.fromJson(
            Map<String, dynamic>.from(resultData),
          );

          print('PARSED GET RESULT: $result');

          return result;
        },
      );
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<List<ScreeningResultModel>>> getHistory({
    required String childId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/screening/history/$childId',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<ScreeningResultModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;

          if (data is List) {
            rawList = data;
          } else if (data is Map && data['history'] is List) {
            rawList = data['history'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => ScreeningResultModel.fromJson(
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