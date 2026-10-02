import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/network/api_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  group('ApiClient Error Contract Handling Tests', () {
    test('parses NestJS GlobalExceptionFilter envelope for 404 NotFound error', () async {
      final requestOptions = RequestOptions(path: '/planner/tasks/123');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
          data: {
            'statusCode': 404,
            'success': false,
            'error': {
              'code': 'ERR_HTTP_404',
              'message': 'Task not found with ID 123',
            },
            'timestamp': '2026-10-02T19:30:00.000Z',
          },
        ),
      );

      when(() => mockDio.get(any())).thenThrow(dioException);

      expect(
        () => apiClient.get('/planner/tasks/123'),
        throwsA(
          isA<NotFoundException>()
              .having((e) => e.message, 'message', 'Task not found with ID 123')
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.type, 'type', 'ERR_HTTP_404'),
        ),
      );
    });

    test('parses NestJS validation array errors into ValidationException', () async {
      final requestOptions = RequestOptions(path: '/finance/expenses');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {
            'statusCode': 400,
            'success': false,
            'error': {
              'code': 'Bad Request',
              'message': [
                'title must not be empty',
                'amount must be greater than 0',
              ],
            },
          },
        ),
      );

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(dioException);

      expect(
        () => apiClient.post('/finance/expenses', data: {}),
        throwsA(
          isA<ValidationException>()
              .having((e) => e.message, 'message', 'title must not be empty, amount must be greater than 0')
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.errors['general'], 'general errors', ['title must not be empty', 'amount must be greater than 0']),
        ),
      );
    });

    test('parses 409 Conflict with custom message as NetworkException with preserved message', () async {
      final requestOptions = RequestOptions(path: '/auth/register');
      final dioException = DioException(
        requestOptions: requestOptions,
        message: 'Request failed with status code 409',
        response: Response(
          requestOptions: requestOptions,
          statusCode: 409,
          data: {
            'statusCode': 409,
            'success': false,
            'error': {
              'code': 'ERR_HTTP_409',
              'message': 'Email address is already registered',
            },
          },
        ),
      );

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(dioException);

      expect(
        () => apiClient.post('/auth/register', data: {}),
        throwsA(
          isA<NetworkException>()
              .having((e) => e.message, 'message', 'Email address is already registered')
              .having((e) => e.statusCode, 'statusCode', 409)
              .having((e) => e.type, 'type', 'ERR_HTTP_409'),
        ),
      );
    });

    test('falls back gracefully to default message if response payload contains no message', () async {
      final requestOptions = RequestOptions(path: '/unknown');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          data: {
            'statusCode': 500,
            'success': false,
          },
        ),
      );

      when(() => mockDio.get(any())).thenThrow(dioException);

      expect(
        () => apiClient.get('/unknown'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'An error occurred')
              .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
