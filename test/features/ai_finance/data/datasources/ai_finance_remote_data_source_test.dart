import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/ai_finance/data/datasources/ai_finance_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AIFinanceRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AIFinanceRemoteDataSourceImpl(mockApiClient);
  });

  test('getFinancialHealth should call POST /finance/ai/summary', () async {
    when(() => mockApiClient.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/finance/ai/summary'),
        statusCode: 200,
        data: {
          'overallScore': 85,
          'wellnessRating': 'EXCELLENT',
          'summaryReasoning': 'Healthy financial wellness',
          'topStrengths': ['Budgeting'],
          'keyRisks': [],
        },
      ),
    );

    final result = await dataSource.getFinancialHealth();

    expect(result.overallScore, equals(85));
    expect(result.wellnessRating, equals('EXCELLENT'));
  });
}
