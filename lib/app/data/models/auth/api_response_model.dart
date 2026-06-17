class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromData,
  }) {
    return ApiResponseModel<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && fromData != null
          ? fromData(json['data'])
          : null,
    );
  }
}