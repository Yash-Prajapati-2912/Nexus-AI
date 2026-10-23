import 'package:nexus_ai/core/network/api_client.dart';
import '../models/ai_finance_history_model.dart';
import '../models/budget_recommendation_model.dart';
import '../models/financial_health_model.dart';
import '../models/forecast_model.dart';
import '../models/goal_analysis_model.dart';
import '../models/savings_recommendation_model.dart';
import '../models/spending_insight_model.dart';
import '../models/subscription_analysis_model.dart';

abstract class IAIFinanceRemoteDataSource {
  Future<FinancialHealthModel> getFinancialHealth();
  Future<SpendingInsightModel> getSpendingInsights();
  Future<ForecastModel> getForecast();
  Future<BudgetRecommendationModel> getBudgetRecommendations();
  Future<SavingsRecommendationModel> getSavingsAdvice();
  Future<SubscriptionAnalysisModel> getSubscriptionAnalysis();
  Future<List<GoalAnalysisModel>> getGoalAnalysis();
  Future<List<AIFinanceHistoryModel>> getAIHistory();
  Future<void> saveReport(String reportId);
  Future<void> deleteReport(String reportId);
}

class AIFinanceRemoteDataSourceImpl implements IAIFinanceRemoteDataSource {
  final ApiClient _apiClient;

  AIFinanceRemoteDataSourceImpl(this._apiClient);

  @override
  Future<FinancialHealthModel> getFinancialHealth() async {
    final response = await _apiClient.post('/finance/ai/summary', data: {});
    final data = response.data as Map<String, dynamic>;
    return FinancialHealthModel.fromJson(data);
  }

  @override
  Future<SpendingInsightModel> getSpendingInsights() async {
    final response = await _apiClient.post('/finance/ai/spending-analysis', data: {});
    final data = response.data as Map<String, dynamic>;
    return SpendingInsightModel.fromJson(data);
  }

  @override
  Future<ForecastModel> getForecast() async {
    final response = await _apiClient.post('/finance/ai/forecast', data: {});
    final data = response.data as Map<String, dynamic>;
    return ForecastModel.fromJson(data);
  }

  @override
  Future<BudgetRecommendationModel> getBudgetRecommendations() async {
    final response = await _apiClient.post('/finance/ai/safe-daily-budget', data: {});
    final data = response.data as Map<String, dynamic>;
    return BudgetRecommendationModel.fromJson(data);
  }

  @override
  Future<SavingsRecommendationModel> getSavingsAdvice() async {
    final response = await _apiClient.post('/finance/ai/savings-plan', data: {});
    final data = response.data as Map<String, dynamic>;
    return SavingsRecommendationModel.fromJson(data);
  }

  @override
  Future<SubscriptionAnalysisModel> getSubscriptionAnalysis() async {
    final response = await _apiClient.post('/finance/ai/financial-review', data: {'reviewType': 'SUBSCRIPTIONS'});
    final data = response.data as Map<String, dynamic>;
    return SubscriptionAnalysisModel.fromJson(data);
  }

  @override
  Future<List<GoalAnalysisModel>> getGoalAnalysis() async {
    final response = await _apiClient.post('/finance/ai/financial-review', data: {'reviewType': 'GOALS'});
    final rawData = response.data;
    final list = (rawData is Map<String, dynamic> && rawData['goals'] is List)
        ? rawData['goals'] as List<dynamic>
        : (rawData is List<dynamic> ? rawData : []);
    return list.map((e) => GoalAnalysisModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<AIFinanceHistoryModel>> getAIHistory() async {
    final response = await _apiClient.get('/finance/ai/history');
    final rawData = response.data;
    final list = rawData is List<dynamic> ? rawData : [];
    return list.map((e) => AIFinanceHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveReport(String reportId) async {
    await _apiClient.post('/finance/ai/history/$reportId/save', data: {});
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _apiClient.delete('/finance/ai/history/$reportId');
  }
}
