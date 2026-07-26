import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_finance/data/datasources/ai_finance_remote_data_source.dart';
import 'package:nexus_ai/features/ai_finance/data/models/financial_health_model.dart';
import 'package:nexus_ai/features/ai_finance/data/repositories/ai_finance_repository_impl.dart';

class MockAIFinanceRemoteDataSource extends Mock implements IAIFinanceRemoteDataSource {}

void main() {
  late AIFinanceRepositoryImpl repository;
  late MockAIFinanceRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAIFinanceRemoteDataSource();
    repository = AIFinanceRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tModel = FinancialHealthModel(
    overallScore: 84,
    budgetHealthScore: 80,
    savingsScore: 88,
    expenseScore: 82,
    incomeStabilityScore: 90,
    cashFlowHealthScore: 85,
    investmentReadinessScore: 75,
    wellnessRating: 'EXCELLENT',
    summaryReasoning: 'Good reasoning',
    topStrengths: ['Savings'],
    keyRisks: [],
  );

  test('should return FinancialHealth when remote data source is successful', () async {
    when(() => mockRemoteDataSource.getFinancialHealth()).thenAnswer((_) async => tModel);

    final result = await repository.getFinancialHealth();

    expect(result, const Right(tModel));
    verify(() => mockRemoteDataSource.getFinancialHealth()).called(1);
  });
}
