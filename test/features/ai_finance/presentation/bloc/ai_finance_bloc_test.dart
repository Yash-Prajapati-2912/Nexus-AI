import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/budget_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/financial_health.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/forecast.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/savings_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/spending_insight.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/subscription_analysis.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_budget_recommendations_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_financial_health_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_forecast_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_savings_advice_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_spending_insights_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/usecases/get_subscription_analysis_usecase.dart';
import 'package:nexus_ai/features/ai_finance/presentation/bloc/ai_finance_bloc.dart';
import 'package:nexus_ai/features/ai_finance/presentation/bloc/ai_finance_event.dart';
import 'package:nexus_ai/features/ai_finance/presentation/bloc/ai_finance_state.dart';

class MockGetFinancialHealthUseCase extends Mock implements GetFinancialHealthUseCase {}
class MockGetSpendingInsightsUseCase extends Mock implements GetSpendingInsightsUseCase {}
class MockGetForecastUseCase extends Mock implements GetForecastUseCase {}
class MockGetBudgetRecommendationsUseCase extends Mock implements GetBudgetRecommendationsUseCase {}
class MockGetSavingsAdviceUseCase extends Mock implements GetSavingsAdviceUseCase {}
class MockGetSubscriptionAnalysisUseCase extends Mock implements GetSubscriptionAnalysisUseCase {}
class MockAIFinanceRepository extends Mock implements IAIFinanceRepository {}

void main() {
  late AIFinanceBloc bloc;
  late MockGetFinancialHealthUseCase mockGetFinancialHealthUseCase;
  late MockGetSpendingInsightsUseCase mockGetSpendingInsightsUseCase;
  late MockGetForecastUseCase mockGetForecastUseCase;
  late MockGetBudgetRecommendationsUseCase mockGetBudgetRecommendationsUseCase;
  late MockGetSavingsAdviceUseCase mockGetSavingsAdviceUseCase;
  late MockGetSubscriptionAnalysisUseCase mockGetSubscriptionAnalysisUseCase;
  late MockAIFinanceRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetFinancialHealthUseCase = MockGetFinancialHealthUseCase();
    mockGetSpendingInsightsUseCase = MockGetSpendingInsightsUseCase();
    mockGetForecastUseCase = MockGetForecastUseCase();
    mockGetBudgetRecommendationsUseCase = MockGetBudgetRecommendationsUseCase();
    mockGetSavingsAdviceUseCase = MockGetSavingsAdviceUseCase();
    mockGetSubscriptionAnalysisUseCase = MockGetSubscriptionAnalysisUseCase();
    mockRepository = MockAIFinanceRepository();

    bloc = AIFinanceBloc(
      getFinancialHealthUseCase: mockGetFinancialHealthUseCase,
      getSpendingInsightsUseCase: mockGetSpendingInsightsUseCase,
      getForecastUseCase: mockGetForecastUseCase,
      getBudgetRecommendationsUseCase: mockGetBudgetRecommendationsUseCase,
      getSavingsAdviceUseCase: mockGetSavingsAdviceUseCase,
      getSubscriptionAnalysisUseCase: mockGetSubscriptionAnalysisUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tHealth = FinancialHealth(
    overallScore: 88,
    budgetHealthScore: 85,
    savingsScore: 90,
    expenseScore: 84,
    incomeStabilityScore: 92,
    cashFlowHealthScore: 87,
    investmentReadinessScore: 78,
    wellnessRating: 'EXCELLENT',
    summaryReasoning: 'Great health',
    topStrengths: ['Savings'],
    keyRisks: [],
  );

  test('initial state should be AIFinanceInitialState', () {
    expect(bloc.state, equals(const AIFinanceInitialState()));
  });

  blocTest<AIFinanceBloc, AIFinanceState>(
    'emits [AIFinanceLoadingState, AIFinanceLoadedState] when LoadFinancialHealthEvent is added',
    build: () {
      when(() => mockGetFinancialHealthUseCase(any())).thenAnswer((_) async => const Right(tHealth));
      when(() => mockGetSpendingInsightsUseCase(any())).thenAnswer((_) async => const Right(SpendingInsight(
            dailyAverageSpent: 20,
            monthlyComparisonPercentage: -5,
            weeklyComparisonPercentage: -2,
            highestCategories: [],
            lifestyleAnalysis: 'Good',
            detectedAnomalies: [],
            confidenceScore: 0.9,
          )));
      when(() => mockGetForecastUseCase(any())).thenAnswer((_) async => const Right(Forecast(
            nextWeekForecastAmount: 100,
            nextMonthForecastAmount: 400,
            quarterlyForecastAmount: 1200,
            yearlyForecastAmount: 4800,
            predictedMonthEndSavings: 500,
            predictedOverspendingRisk: false,
            overspendingProbability: 0.1,
            projectedCashFlowSeries: [400],
            forecastExplanation: 'Fine',
          )));
      when(() => mockGetBudgetRecommendationsUseCase(any())).thenAnswer((_) async => const Right(BudgetRecommendation(
            safeDailySpendingLimit: 30,
            recommendedTotalMonthlyBudget: 900,
            categoryAdjustments: [],
            optimizationStrategy: 'Fine',
          )));
      when(() => mockGetSavingsAdviceUseCase(any())).thenAnswer((_) async => const Right(SavingsRecommendation(
            totalPotentialMonthlySavings: 100,
            tips: [],
            aiStrategySummary: 'Fine',
          )));
      when(() => mockGetSubscriptionAnalysisUseCase(any())).thenAnswer((_) async => const Right(SubscriptionAnalysis(
            totalMonthlySubscriptionCost: 30,
            activeSubscriptionCount: 2,
            unusedCount: 0,
            potentialMonthlySavingsFromCancellation: 0,
            subscriptions: [],
          )));
      when(() => mockRepository.getGoalAnalysis()).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (b) => b.add(const LoadFinancialHealthEvent()),
    expect: () => [
      const AIFinanceLoadingState(),
      isA<AIFinanceLoadedState>(),
    ],
  );
}
