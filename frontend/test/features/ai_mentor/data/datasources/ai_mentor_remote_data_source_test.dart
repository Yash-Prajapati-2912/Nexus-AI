import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/ai_mentor/data/datasources/ai_mentor_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AIMentorRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AIMentorRemoteDataSourceImpl(mockApiClient);
  });

  test('getWellnessScores should call GET /mentor/wellness-scores', () async {
    when(() => mockApiClient.get(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/mentor/wellness-scores'),
        statusCode: 200,
        data: {
          'overallWellnessScore': 88,
          'wellnessLevel': 'EXCELLENT',
          'keyRecommendations': ['Great job'],
        },
      ),
    );

    final result = await dataSource.getWellnessScores();

    expect(result.overallWellnessScore, equals(88));
    expect(result.wellnessLevel, equals('EXCELLENT'));
  });
}
