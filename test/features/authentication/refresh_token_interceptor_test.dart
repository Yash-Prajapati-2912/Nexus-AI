import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/config/constants/api_constants.dart';
import 'package:nexus_ai/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:nexus_ai/core/storage/secure_token_storage.dart';

class MockDio extends Mock implements Dio {}
class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late MockDio mockDio;
  late MockSecureTokenStorage mockTokenStorage;
  late MockErrorInterceptorHandler mockHandler;
  late RefreshTokenInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    mockTokenStorage = MockSecureTokenStorage();
    mockHandler = MockErrorInterceptorHandler();
    interceptor = RefreshTokenInterceptor(
      dio: mockDio,
      tokenStorage: mockTokenStorage,
    );
  });

  group('RefreshTokenInterceptor Tests', () {
    test('successfully extracts tokens from nested envelope and retries request', () async {
      final requestOptions = RequestOptions(
        path: '/planner/tasks',
        headers: {'Authorization': 'Bearer old_access_token'},
      );
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      when(() => mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => 'valid_refresh_token');

      // Backend returns standard envelope with tokens nested
      when(() => mockDio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': 'valid_refresh_token'},
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.refreshToken),
            statusCode: 200,
            data: {
              'statusCode': 200,
              'success': true,
              'data': {
                'user': {'id': 'user-123'},
                'tokens': {
                  'accessToken': 'new_access_token',
                  'refreshToken': 'new_refresh_token',
                },
              },
            },
          ));

      when(() => mockTokenStorage.saveTokens(
            accessToken: 'new_access_token',
            refreshToken: 'new_refresh_token',
          )).thenAnswer((_) async {});

      final retriedResponse = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'success': true},
      );

      when(() => mockDio.fetch(any())).thenAnswer((_) async => retriedResponse);

      await interceptor.onError(dioException, mockHandler);

      verify(() => mockTokenStorage.saveTokens(
            accessToken: 'new_access_token',
            refreshToken: 'new_refresh_token',
          )).called(1);
      verify(() => mockHandler.resolve(retriedResponse)).called(1);
      verifyNever(() => mockTokenStorage.clearTokens());
    });

    test('successfully extracts tokens from flat data and retries request', () async {
      final requestOptions = RequestOptions(
        path: '/finance/expenses',
        headers: {'Authorization': 'Bearer old_access_token'},
      );
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      when(() => mockTokenStorage.getRefreshToken())
          .thenAnswer((_) async => 'valid_refresh_token');

      // Flat data
      when(() => mockDio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': 'valid_refresh_token'},
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ApiConstants.refreshToken),
            statusCode: 200,
            data: {
              'data': {
                'accessToken': 'new_flat_access',
                'refreshToken': 'new_flat_refresh',
              },
            },
          ));

      when(() => mockTokenStorage.saveTokens(
            accessToken: 'new_flat_access',
            refreshToken: 'new_flat_refresh',
          )).thenAnswer((_) async {});

      final retriedResponse = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'success': true},
      );

      when(() => mockDio.fetch(any())).thenAnswer((_) async => retriedResponse);

      await interceptor.onError(dioException, mockHandler);

      verify(() => mockTokenStorage.saveTokens(
            accessToken: 'new_flat_access',
            refreshToken: 'new_flat_refresh',
          )).called(1);
      verify(() => mockHandler.resolve(retriedResponse)).called(1);
    });

    test('when refresh request itself receives 401, skips refresh and forwards error', () async {
      final requestOptions = RequestOptions(path: ApiConstants.refreshToken);
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      await interceptor.onError(dioException, mockHandler);

      verifyNever(() => mockTokenStorage.getRefreshToken());
      verifyNever(() => mockDio.post(any(), data: any(named: 'data')));
      verify(() => mockHandler.next(dioException)).called(1);
    });
  });
}
