import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/psikolog_model.dart';
import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class PsikologService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<List<PsikologModel>>> getAllPsikolog({
    String? search,
    String? type,
    String? city,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/psikolog/',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (type != null && type.isNotEmpty) 'type': type,
          if (city != null && city.isNotEmpty) 'city': city,
          'limit': 50, // Get more items
        },
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<PsikologModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;
          if (data is List) {
            rawList = data;
          } else if (data is Map && data['experts'] is List) {
            rawList = data['experts'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => PsikologModel.fromJson(
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

  Future<ApiResponseModel<PsikologModel>> getPsikologById(String id) async {
    try {
      final response = await _apiService.dio.get(
        '/api/psikolog/$id',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<PsikologModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => PsikologModel.fromJson(
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
