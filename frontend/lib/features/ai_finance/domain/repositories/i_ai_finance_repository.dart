import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/ai_finance_history_item.dart';
import '../entities/budget_recommendation.dart';
import '../entities/financial_health.dart';
import '../entities/forecast.dart';
import '../entities/goal_analysis.dart';
import '../entities/savings_recommendation.dart';
import '../entities/spending_insight.dart';
import '../entities/subscription_analysis.dart';

abstract class IAIFinanceRepository {
  Future<Either<Failure, FinancialHealth>> getFinancialHealth();
  Future<Either<Failure, SpendingInsight>> getSpendingInsights();
  Future<Either<Failure, Forecast>> getForecast();
  Future<Either<Failure, BudgetRecommendation>> getBudgetRecommendations();
  Future<Either<Failure, SavingsRecommendation>> getSavingsAdvice();
  Future<Either<Failure, SubscriptionAnalysis>> getSubscriptionAnalysis();
  Future<Either<Failure, List<GoalAnalysis>>> getGoalAnalysis();
  Future<Either<Failure, List<AIFinanceHistoryItem>>> getAIHistory();
  Future<Either<Failure, Unit>> saveReport(String reportId);
  Future<Either<Failure, Unit>> deleteReport(String reportId);
}
