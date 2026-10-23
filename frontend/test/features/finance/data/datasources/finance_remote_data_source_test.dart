import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/finance/data/datasources/finance_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late FinanceRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = FinanceRemoteDataSourceImpl(mockApiClient);
  });

  test('getExpenses should send GET request to /finance/expenses and parse list', () async {
    when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/finance/expenses'),
        statusCode: 200,
        data: [
          {
            'id': 'exp-1',
            'title': 'Coffee',
            'amount': 4.5,
            'categoryId': 'c-1',
            'categoryName': 'Food',
            'categoryIcon': 'fastfood',
            'date': '2026-07-26T00:00:00.000Z',
          }
        ],
      ),
    );

    final result = await dataSource.getExpenses();

    expect(result.length, equals(1));
    expect(result.first.title, equals('Coffee'));
    expect(result.first.amount, equals(4.5));
  });
}
