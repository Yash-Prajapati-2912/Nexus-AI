import 'package:dio/dio.dart';
import '../../../config/constants/app_constants.dart';
import '../../services/logger_service.dart';

/// Interceptor executing automatic retry with exponential backoff on transient network timeouts and server 503 errors.
class RetryInterceptor extends Interceptor {
  final Dio _dio;

  RetryInterceptor({required Dio dio}) : _dio = dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      var attempt = 0;
      while (attempt < AppConstants.maxRetryAttempts) {
        attempt++;
        try {
          LoggerService.warning('Retrying network request (Attempt $attempt)...');
          await Future.delayed(Duration(seconds: attempt * 2));
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          if (attempt >= AppConstants.maxRetryAttempts) {
            break;
          }
        }
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode == 503);
  }
}
