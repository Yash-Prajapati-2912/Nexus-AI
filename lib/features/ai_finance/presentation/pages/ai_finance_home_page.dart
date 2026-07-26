import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/budget_recommendation.dart';
import '../../domain/entities/financial_health.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/savings_recommendation.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/subscription_analysis.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';
import '../widgets/ai_finance_skeleton.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/budget_recommendation_card.dart';
import '../widgets/financial_health_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/mini_finance_assistant_panel.dart';
import '../widgets/savings_card.dart';
import '../widgets/subscription_card.dart';

class AIFinanceHomePage extends StatefulWidget {
  const AIFinanceHomePage({super.key});

  @override
  State<AIFinanceHomePage> createState() => _AIFinanceHomePageState();
}

class _AIFinanceHomePageState extends State<AIFinanceHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Financial Advisor', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.aiFinanceHistory),
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            onPressed: () => context.push(RouteNames.aiFinanceSavedInsights),
            tooltip: 'Saved Insights',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RouteNames.aiFinanceSettings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AIFinanceBloc>().add(const RefreshAIFinanceDashboardEvent());
        },
        child: BlocBuilder<AIFinanceBloc, AIFinanceState>(
          builder: (context, state) {
            if (state is AIFinanceLoadingState) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    AIFinanceSkeleton(height: 120),
                    SizedBox(height: 16),
                    AIFinanceSkeleton(height: 140),
                    SizedBox(height: 16),
                    AIFinanceSkeleton(height: 140),
                  ],
                ),
              );
            }

            final health = (state is AIFinanceLoadedState)
                ? state.health
                : const FinancialHealth(
                    overallScore: 84,
                    budgetHealthScore: 80,
                    savingsScore: 88,
                    expenseScore: 82,
                    incomeStabilityScore: 90,
                    cashFlowHealthScore: 85,
                    investmentReadinessScore: 75,
                    wellnessRating: 'EXCELLENT',
                    summaryReasoning: 'Your overall financial health is strong with stable net savings.',
                    topStrengths: ['Consistent income', 'Disciplined budgeting'],
                    keyRisks: ['Dining out overhead'],
                  );

            final insight = (state is AIFinanceLoadedState)
                ? state.insight
                : const SpendingInsight(
                    dailyAverageSpent: 28.50,
                    monthlyComparisonPercentage: -12.4,
                    weeklyComparisonPercentage: -4.2,
                    highestCategories: [],
                    lifestyleAnalysis: 'Moderate student lifestyle spending.',
                    detectedAnomalies: [],
                    confidenceScore: 0.94,
                  );

            final forecast = (state is AIFinanceLoadedState)
                ? state.forecast
                : const Forecast(
                    nextWeekForecastAmount: 180,
                    nextMonthForecastAmount: 820,
                    quarterlyForecastAmount: 2450,
                    yearlyForecastAmount: 9800,
                    predictedMonthEndSavings: 1450,
                    predictedOverspendingRisk: false,
                    overspendingProbability: 0.15,
                    projectedCashFlowSeries: [850, 920, 780, 1100],
                    forecastExplanation: 'Positive cash flow trajectory expected.',
                  );

            final budgetRec = (state is AIFinanceLoadedState)
                ? state.budgetRec
                : const BudgetRecommendation(
                    safeDailySpendingLimit: 32.50,
                    recommendedTotalMonthlyBudget: 950.00,
                    categoryAdjustments: [],
                    optimizationStrategy: 'Optimal daily limit established.',
                  );

            final savingsRec = (state is AIFinanceLoadedState)
                ? state.savingsRec
                : const SavingsRecommendation(
                    totalPotentialMonthlySavings: 160.00,
                    tips: [],
                    aiStrategySummary: 'Potential \$160/mo savings identified.',
                  );

            final subscriptions = (state is AIFinanceLoadedState)
                ? state.subscriptions
                : const SubscriptionAnalysis(
                    totalMonthlySubscriptionCost: 49.99,
                    activeSubscriptionCount: 4,
                    unusedCount: 1,
                    potentialMonthlySavingsFromCancellation: 14.99,
                    subscriptions: [],
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinancialHealthCard(
                    health: health,
                    onTap: () => context.push(RouteNames.aiFinanceHealthDashboard),
                  ),

                  const SizedBox(height: 16),
                  const MiniFinanceAssistantPanel(),

                  const SizedBox(height: 16),
                  AIInsightCard(
                    insight: insight,
                    onTap: () => context.push(RouteNames.aiFinanceSpendingInsights),
                  ),

                  ForecastCard(forecast: forecast),

                  BudgetRecommendationCard(recommendation: budgetRec),

                  SavingsCard(savings: savingsRec),

                  SubscriptionCard(
                    analysis: subscriptions,
                    onTap: () => context.push(RouteNames.aiFinanceSubscriptionAnalysis),
                  ),

                  const SizedBox(height: 24),
                  // Quick Actions for remaining screens
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.timeline_rounded, size: 16),
                        label: const Text('Cash Flow Prediction'),
                        onPressed: () => context.push(RouteNames.aiFinanceCashFlowPrediction),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.flag_rounded, size: 16),
                        label: const Text('Goals Advisor'),
                        onPressed: () => context.push(RouteNames.aiFinanceGoalsAdvisor),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.warning_amber_rounded, size: 16),
                        label: const Text('Unusual Spending'),
                        onPressed: () => context.push(RouteNames.aiFinanceUnusualSpending),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.bar_chart_rounded, size: 16),
                        label: const Text('Monthly AI Report'),
                        onPressed: () => context.push(RouteNames.aiFinanceMonthlyReport),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.pie_chart_rounded, size: 16),
                        label: const Text('Yearly AI Report'),
                        onPressed: () => context.push(RouteNames.aiFinanceYearlyReport),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
