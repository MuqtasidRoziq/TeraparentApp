import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'api_service.dart';
import '../models/auth/api_response_model.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  final userPhotoUrl = ''.obs;
  final userFullName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userPhotoUrl.value = prefs.getString('photo_url') ?? '';
      userFullName.value = prefs.getString('full_name') ?? '';
    } catch (e) {
      debugPrint('Error loading user data in UserService: $e');
    }
  }

  Future<ApiResponseModel<dynamic>> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '/api/users/profile',
        data: {
          'fullName': fullName,
          'phone': phone,
        },
        options: await _apiService.authOptions(),
      );

      final result = ApiResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => data,
      );

      if (result.success) {
        userFullName.value = fullName;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('full_name', fullName);
        await prefs.setString('phone', phone);
      }

      return result;
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ApiResponseModel<dynamic>> uploadProfilePhoto(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final authOpts = await _apiService.authOptions();
      final uploadOptions = Options(
        headers: {
          ...?authOpts.headers,
          'Content-Type': 'multipart/form-data',
        },
      );

      final response = await _apiService.dio.put(
        '/api/users/profile/photo',
        data: formData,
        options: uploadOptions,
      );

      final result = ApiResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
        fromData: (data) => data,
      );

      if (result.success && result.data != null) {
        final data = result.data;
        String? newUrl;
        if (data is Map) {
          newUrl = data['photoUrl']?.toString() ?? data['photo_url']?.toString() ?? data['url']?.toString();
        }
        if (newUrl != null && newUrl.isNotEmpty) {
          userPhotoUrl.value = newUrl;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('photo_url', newUrl);
        }
      }

      return result;
    } on DioException catch (e) {
      throw _apiService.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
