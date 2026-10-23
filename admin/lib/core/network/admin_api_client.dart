import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminApiClient {
  late final Dio dio;

  AdminApiClient(SharedPreferences prefs) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getString('admin_jwt_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            prefs.remove('admin_jwt_token');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    return dio.post<T>(path, data: data);
  }

  Future<Response<T>> patch<T>(String path, {dynamic data}) async {
    return dio.patch<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) async {
    return dio.delete<T>(path);
  }
}
