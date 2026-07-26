/// Standard HTTP API JSON Response Envelope matching backend specs.
class ApiResponseWrapper<T> {
  final int statusCode;
  final bool success;
  final T? data;
  final String? message;
  final String timestamp;

  const ApiResponseWrapper({
    required this.statusCode,
    required this.success,
    this.data,
    this.message,
    required this.timestamp,
  });

  factory ApiResponseWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponseWrapper<T>(
      statusCode: json['statusCode'] as int? ?? 200,
      success: json['success'] as bool? ?? true,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}
