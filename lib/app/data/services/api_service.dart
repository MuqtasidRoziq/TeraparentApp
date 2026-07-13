import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://teraservices.vercel.app/',
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ),
        );

  Future<Options> authOptions() async {
    final token = await _storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw 'Token tidak ditemukan. Silakan login ulang.';
    }

    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  String handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      return 'Terjadi kesalahan pada server';
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Periksa koneksi internet anda';
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server terlalu lama merespons';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server';
    }

    return 'Terjadi kesalahan jaringan';
  }
}
