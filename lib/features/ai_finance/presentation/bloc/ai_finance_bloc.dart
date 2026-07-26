import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/budget_recommendation.dart';
import '../../domain/entities/financial_health.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/savings_recommendation.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/subscription_analysis.dart';


import '../../domain/usecases/get_budget_recommendations_usecase.dart';
import '../../domain/usecases/get_financial_health_usecase.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../domain/usecases/get_savings_advice_usecase.dart';
import '../../domain/usecases/get_spending_insights_usecase.dart';
import '../../domain/usecases/get_subscription_analysis_usecase.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

import 'ai_finance_event.dart';
import 'ai_finance_state.dart';

class AIFinanceBloc extends Bloc<AIFinanceEvent, AIFinanceState> {
  final GetFinancialHealthUseCase getFinancialHealthUseCase;
  final GetSpendingInsightsUseCase getSpendingInsightsUseCase;
  final GetForecastUseCase getForecastUseCase;
  final GetBudgetRecommendationsUseCase getBudgetRecommendationsUseCase;
  final GetSavingsAdviceUseCase getSavingsAdviceUseCase;
  final GetSubscriptionAnalysisUseCase getSubscriptionAnalysisUseCase;
  final IAIFinanceRepository repository;

  AIFinanceBloc({
    required this.getFinancialHealthUseCase,
    required this.getSpendingInsightsUseCase,
    required this.getForecastUseCase,
    required this.getBudgetRecommendationsUseCase,
    required this.getSavingsAdviceUseCase,
    required this.getSubscriptionAnalysisUseCase,
    required this.repository,
  }) : super(const AIFinanceInitialState()) {
    on<LoadFinancialHealthEvent>(_onLoadHealth);
    on<RefreshAIFinanceDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadHealth(
    LoadFinancialHealthEvent event,
    Emitter<AIFinanceState> emit,
  ) async {
    emit(const AIFinanceLoadingState());

    final healthRes = await getFinancialHealthUseCase(const NoParams());
    final insightRes = await getSpendingInsightsUseCase(const NoParams());
    final forecastRes = await getForecastUseCase(const NoParams());
    final budgetRes = await getBudgetRecommendationsUseCase(const NoParams());
    final savingsRes = await getSavingsAdviceUseCase(const NoParams());
    final subRes = await getSubscriptionAnalysisUseCase(const NoParams());
    final goalRes = await repository.getGoalAnalysis();

    healthRes.fold(
      (Failure f) => emit(AIFinanceFailureState(message: f.message)),
      (health) {
        emit(AIFinanceLoadedState(
          health: health,
          insight: insightRes.getOrElse((_) => const SpendingInsight(
                dailyAverageSpent: 28.50,
                monthlyComparisonPercentage: -12.4,
                weeklyComparisonPercentage: -4.2,
                highestCategories: [],
                lifestyleAnalysis: 'Moderate lifestyle spending.',
                detectedAnomalies: [],
                confidenceScore: 0.94,
              )),
          forecast: forecastRes.getOrElse((_) => const Forecast(
                nextWeekForecastAmount: 180,
                nextMonthForecastAmount: 820,
                quarterlyForecastAmount: 2450,
                yearlyForecastAmount: 9800,
                predictedMonthEndSavings: 1450,
                predictedOverspendingRisk: false,
                overspendingProbability: 0.15,
                projectedCashFlowSeries: [850, 920, 780, 1100],
                forecastExplanation: 'Positive cash flow projection.',
              )),
          budgetRec: budgetRes.getOrElse((_) => const BudgetRecommendation(
                safeDailySpendingLimit: 32.50,
                recommendedTotalMonthlyBudget: 950.00,
                categoryAdjustments: [],
                optimizationStrategy: 'Optimized budget balance.',
              )),
          savingsRec: savingsRes.getOrElse((_) => const SavingsRecommendation(
                totalPotentialMonthlySavings: 160.00,
                tips: [],
                aiStrategySummary: 'Cancel unused subscriptions and optimize grocery buying.',
              )),
          subscriptions: subRes.getOrElse((_) => const SubscriptionAnalysis(
                totalMonthlySubscriptionCost: 49.99,
                activeSubscriptionCount: 4,
                unusedCount: 1,
                potentialMonthlySavingsFromCancellation: 14.99,
                subscriptions: [],
              )),
          goals: goalRes.getOrElse((_) => []),
        ));
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshAIFinanceDashboardEvent event,
    Emitter<AIFinanceState> emit,
  ) async {
    add(const LoadFinancialHealthEvent());
  }
}
