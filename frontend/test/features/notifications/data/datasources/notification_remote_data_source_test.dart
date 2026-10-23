import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/notifications/data/datasources/notification_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late NotificationRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = NotificationRemoteDataSourceImpl(mockApiClient);
  });

  test('getNotifications should call GET /notifications and return NotificationModel list', () async {
    when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/notifications'),
        statusCode: 200,
        data: [
          {
            'id': 'n1',
            'userId': 'u1',
            'title': 'Assignment Due',
            'body': 'Submit by 11:59 PM',
            'type': 'PLANNER',
            'module': 'PLANNER',
            'category': 'ASSIGNMENT',
            'priority': 'HIGH',
            'createdAt': DateTime.now().toIso8601String(),
          }
        ],
      ),
    );

    final result = await dataSource.getNotifications();

    expect(result.length, equals(1));
    expect(result.first.title, equals('Assignment Due'));
  });
}
