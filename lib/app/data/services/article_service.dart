import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:teraparent_mobile/app/data/models/article_model.dart';
import '../models/auth/api_response_model.dart';
import 'api_service.dart';

class ArticleService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponseModel<List<ArticleModel>>> getAllArticles({
    String? kategori,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/api/articles/',
        queryParameters: {
          if (kategori != null && kategori.isNotEmpty) 'kategori': kategori,
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<List<ArticleModel>>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) {
          final List rawList;
          if (data is List) {
            rawList = data;
          } else if (data is Map && data['articles'] is List) {
            rawList = data['articles'];
          } else {
            rawList = [];
          }

          return rawList
              .map(
                (item) => ArticleModel.fromJson(
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

  Future<ApiResponseModel<ArticleModel>> getArticleById(String id) async {
    try {
      final response = await _apiService.dio.get(
        '/api/articles/$id',
        options: await _apiService.authOptions(),
      );

      return ApiResponseModel<ArticleModel>.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => ArticleModel.fromJson(
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
