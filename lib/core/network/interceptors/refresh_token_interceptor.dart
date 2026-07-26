import 'package:dio/dio.dart';
import '../../../config/constants/api_constants.dart';
import '../../storage/secure_token_storage.dart';
import '../../services/logger_service.dart';

/// Interceptor catching 401 Unauthorized errors and executing a mutex-locked automatic refresh token flow.
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final SecureTokenStorage _tokenStorage;
  bool _isRefreshing = false;

  RefreshTokenInterceptor({
    required Dio dio,
    required SecureTokenStorage tokenStorage,
  })  : _dio = dio,
        _tokenStorage = tokenStorage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshTokenRequest(err.requestOptions)) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = await _tokenStorage.getRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            await _tokenStorage.clearTokens();
            return handler.next(err);
          }

          final response = await _dio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final data = response.data['data'] as Map<String, dynamic>;
            final newAccessToken = data['accessToken'] as String;
            final newRefreshToken = data['refreshToken'] as String;

            await _tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Retry original failed request
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            final cloneReq = await _dio.fetch(opts);
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          LoggerService.error('Token refresh failed', e);
          await _tokenStorage.clearTokens();
        } finally {
          _isRefreshing = false;
        }
      }
    }
    handler.next(err);
  }

  bool _isRefreshTokenRequest(RequestOptions options) {
    return options.path.contains(ApiConstants.refreshToken);
  }
}
