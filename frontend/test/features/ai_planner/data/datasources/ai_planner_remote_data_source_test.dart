import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/ai_planner/data/datasources/ai_planner_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AIPlannerRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AIPlannerRemoteDataSourceImpl(mockApiClient);
  });

  test('generateStudyPlan posts data to /planner/ai/study-plan', () async {
    final responsePayload = {
      'id': 'res-1',
      'title': 'Generated Plan',
      'summary': 'AI generated summary',
      'timeframe': 'weekly',
      'reasoning': [],
      'actionItems': [],
      'warnings': [],
      'confidenceScore': 0.95,
      'providerName': 'GEMINI',
      'createdAt': DateTime.now().toIso8601String(),
    };

    when(() => mockApiClient.post('/planner/ai/study-plan', data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/planner/ai/study-plan'),
              data: responsePayload,
              statusCode: 200,
            ));

    final result = await dataSource.generateStudyPlan(timeframe: 'weekly');

    expect(result.id, equals('res-1'));
    verify(() => mockApiClient.post('/planner/ai/study-plan', data: {'timeframe': 'weekly'})).called(1);
  });
}
