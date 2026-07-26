import 'package:dio/dio.dart';
import '../../services/logger_service.dart';

/// Logging Interceptor for HTTP requests and responses.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerService.debug('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    LoggerService.debug('<-- ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerService.error('HTTP ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}');
    handler.next(err);
  }
}
