import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_recommendation.dart';
import '../../domain/entities/financial_health.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/goal_analysis.dart';
import '../../domain/entities/savings_recommendation.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/subscription_analysis.dart';

abstract class AIFinanceState extends Equatable {
  const AIFinanceState();

  @override
  List<Object?> get props => [];
}

class AIFinanceInitialState extends AIFinanceState {
  const AIFinanceInitialState();
}

class AIFinanceLoadingState extends AIFinanceState {
  const AIFinanceLoadingState();
}

class AIFinanceFailureState extends AIFinanceState {
  final String message;

  const AIFinanceFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AIFinanceLoadedState extends AIFinanceState {
  final FinancialHealth health;
  final SpendingInsight insight;
  final Forecast forecast;
  final BudgetRecommendation budgetRec;
  final SavingsRecommendation savingsRec;
  final SubscriptionAnalysis subscriptions;
  final List<GoalAnalysis> goals;

  const AIFinanceLoadedState({
    required this.health,
    required this.insight,
    required this.forecast,
    required this.budgetRec,
    required this.savingsRec,
    required this.subscriptions,
    required this.goals,
  });

  @override
  List<Object?> get props => [
        health,
        insight,
        forecast,
        budgetRec,
        savingsRec,
        subscriptions,
        goals,
      ];
}
