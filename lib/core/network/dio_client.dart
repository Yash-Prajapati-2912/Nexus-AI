import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../config/env/app_env.dart';
import '../storage/secure_token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Pre-configured Dio HTTP Client factory instance.
class DioClient {
  static Dio createDio(SecureTokenStorage tokenStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnv.current.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppEnv.current.connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: AppEnv.current.receiveTimeoutMs),
        sendTimeout: kIsWeb ? null : Duration(milliseconds: AppEnv.current.receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      RefreshTokenInterceptor(dio: dio, tokenStorage: tokenStorage),
      RetryInterceptor(dio: dio),
      if (AppEnv.current.enableNetworkLogging) LoggingInterceptor(),
      if (AppEnv.current.enableNetworkLogging)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
    ]);

    return dio;
  }
}
