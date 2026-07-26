import 'package:dio/dio.dart';
import '../error/exceptions.dart';

/// Base REST API Client performing HTTP verb execution & RFC 7807 error translation.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  NetworkException _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const TimeoutException(message: 'Request connection timed out.');
    }

    if (response != null && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final message = data['detail'] as String? ?? data['message'] as String? ?? 'An error occurred';
      final type = data['type'] as String?;

      if (statusCode == 400) {
        final errorsMap = <String, List<String>>{};
        if (data['errors'] is Map<String, dynamic>) {
          (data['errors'] as Map<String, dynamic>).forEach((key, value) {
            if (value is List) {
              errorsMap[key] = value.map((e) => e.toString()).toList();
            }
          });
        }
        return ValidationException(message: message, errors: errorsMap, type: type);
      }

      if (statusCode == 401) {
        return UnauthorizedException(message: message, type: type);
      }

      if (statusCode == 403) {
        return ForbiddenException(message: message, type: type);
      }

      if (statusCode == 404) {
        return NotFoundException(message: message, type: type);
      }

      if (statusCode != null && statusCode >= 500) {
        return ServerException(message: message, statusCode: statusCode, type: type);
      }
    }

    return NetworkException(
      message: error.message ?? 'Network error occurred',
      statusCode: statusCode,
    );
  }
}
