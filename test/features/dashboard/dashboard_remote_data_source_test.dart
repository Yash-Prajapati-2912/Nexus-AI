import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/config/constants/api_constants.dart';
import 'package:nexus_ai/core/network/api_client.dart';
import 'package:nexus_ai/features/dashboard/data/datasources/dashboard_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late DashboardRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = DashboardRemoteDataSourceImpl(mockApiClient);
  });

  group('DashboardRemoteDataSourceImpl API Contract Tests', () {
    test('getPlannerSummary should call GET /planner/productivity/summary and parse DTO', () async {
      when(() => mockApiClient.get(ApiConstants.plannerSummary)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.plannerSummary),
          statusCode: 200,
          data: {
            'tasksCompleted': 42,
            'assignmentsCompleted': 12,
            'studyHours': 38.5,
            'completionRate': 87.5,
            'streakDays': 7,
            'missedDeadlines': 2,
          },
        ),
      );

      final result = await dataSource.getPlannerSummary();

      verify(() => mockApiClient.get(ApiConstants.plannerSummary)).called(1);
      expect(ApiConstants.plannerSummary, equals('/planner/productivity/summary'));
      expect(result.completedTasksCount, equals(42));
      expect(result.studyProgressPercentage, equals(0.875));
    });

    test('getFinanceSummary should call GET /finance/summary and parse DTO', () async {
      when(() => mockApiClient.get(ApiConstants.financeSummary)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.financeSummary),
          statusCode: 200,
          data: {
            'month': 7,
            'year': 2026,
            'totalIncome': 5000.0,
            'totalExpenses': 2350.0,
            'remainingBudget': 1650.0,
            'savings': 2650.0,
            'budgetUtilisationPercentage': 58.75,
          },
        ),
      );

      final result = await dataSource.getFinanceSummary();

      verify(() => mockApiClient.get(ApiConstants.financeSummary)).called(1);
      expect(ApiConstants.financeSummary, equals('/finance/summary'));
      expect(result.totalIncome, equals(5000.0));
      expect(result.spentThisMonth, equals(2350.0));
      expect(result.remainingBudget, equals(1650.0));
    });

    test('getAiInsights should call GET /dashboard/insights and parse insights list envelope', () async {
      when(() => mockApiClient.get(ApiConstants.dashboardInsights)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.dashboardInsights),
          statusCode: 200,
          data: {
            'insights': [
              {
                'id': 'ins-1',
                'title': 'High Productivity Zone',
                'summary': 'Your morning focus block yields 30% higher completion rates.',
                'detail': 'Consistency is the key to mastery.',
                'priorityLevel': 'HIGH',
                'domainCategory': 'PLANNER',
              }
            ],
          },
        ),
      );

      final result = await dataSource.getAiInsights();

      verify(() => mockApiClient.get(ApiConstants.dashboardInsights)).called(1);
      expect(ApiConstants.dashboardInsights, equals('/dashboard/insights'));
      expect(result.title, equals('High Productivity Zone'));
      expect(result.insight, equals('Your morning focus block yields 30% higher completion rates.'));
      expect(result.motivationalQuote, equals('Consistency is the key to mastery.'));
    });
  });
}
