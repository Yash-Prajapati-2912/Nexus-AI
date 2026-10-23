import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/budget_recommendation.dart';
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
                dailyAverageSpent: 0.0,
                monthlyComparisonPercentage: 0.0,
                weeklyComparisonPercentage: 0.0,
                highestCategories: [],
                lifestyleAnalysis: 'No spending insights available.',
                detectedAnomalies: [],
                confidenceScore: 0.0,
              )),
          forecast: forecastRes.getOrElse((_) => const Forecast(
                nextWeekForecastAmount: 0.0,
                nextMonthForecastAmount: 0.0,
                quarterlyForecastAmount: 0.0,
                yearlyForecastAmount: 0.0,
                predictedMonthEndSavings: 0.0,
                predictedOverspendingRisk: false,
                overspendingProbability: 0.0,
                projectedCashFlowSeries: [],
                forecastExplanation: 'No forecast data available.',
              )),
          budgetRec: budgetRes.getOrElse((_) => const BudgetRecommendation(
                safeDailySpendingLimit: 0.0,
                recommendedTotalMonthlyBudget: 0.0,
                categoryAdjustments: [],
                optimizationStrategy: 'No budget recommendations available.',
              )),
          savingsRec: savingsRes.getOrElse((_) => const SavingsRecommendation(
                totalPotentialMonthlySavings: 0.0,
                tips: [],
                aiStrategySummary: 'No savings advice available.',
              )),
          subscriptions: subRes.getOrElse((_) => const SubscriptionAnalysis(
                totalMonthlySubscriptionCost: 0.0,
                activeSubscriptionCount: 0,
                unusedCount: 0,
                potentialMonthlySavingsFromCancellation: 0.0,
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
