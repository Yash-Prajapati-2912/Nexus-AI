import 'package:nexus_ai/core/network/api_client.dart';
import '../models/ai_history_model.dart';

import '../models/deadline_risk_model.dart';
import '../models/priority_optimizer_model.dart';
import '../models/productivity_insight_model.dart';
import '../models/recommendation_model.dart';
import '../models/study_plan_model.dart';
import '../models/workload_model.dart';

abstract class IAIPlannerRemoteDataSource {
  Future<StudyPlanModel> generateStudyPlan({
    required String timeframe,
    List<String>? targetSubjects,
    int? dailyGoalMinutes,
  });

  Future<PriorityOptimizerModel> prioritizeTasks({
    List<String>? taskIds,
  });

  Future<WorkloadModel> getWorkloadAnalysis();

  Future<ProductivityInsightModel> getProductivityInsights();

  Future<DeadlineRiskModel> getDeadlineRiskAnalysis();

  Future<List<RecommendationModel>> getRecommendations();

  Future<List<AIHistoryModel>> getAIHistory();

  Future<StudyPlanModel> savePlan(StudyPlanModel plan);

  Future<void> deletePlan(String planId);

  Future<void> deleteHistoryItem(String historyId);
}

class AIPlannerRemoteDataSourceImpl implements IAIPlannerRemoteDataSource {
  final ApiClient _apiClient;

  AIPlannerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StudyPlanModel> generateStudyPlan({
    required String timeframe,
    List<String>? targetSubjects,
    int? dailyGoalMinutes,
  }) async {
    final response = await _apiClient.post(
      '/planner/ai/study-plan',
      data: {
        'timeframe': timeframe,
        if (targetSubjects != null) 'targetSubjects': targetSubjects,
        if (dailyGoalMinutes != null) 'dailyGoalMinutes': dailyGoalMinutes,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return StudyPlanModel.fromJson(data);
  }

  @override
  Future<PriorityOptimizerModel> prioritizeTasks({
    List<String>? taskIds,
  }) async {
    final response = await _apiClient.post(
      '/planner/ai/prioritise',
      data: {
        if (taskIds != null) 'taskIds': taskIds,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return PriorityOptimizerModel.fromJson(data);
  }

  @override
  Future<WorkloadModel> getWorkloadAnalysis() async {
    final response = await _apiClient.post('/planner/ai/workload-analysis');
    final data = response.data as Map<String, dynamic>;
    return WorkloadModel.fromJson(data);
  }

  @override
  Future<ProductivityInsightModel> getProductivityInsights() async {
    final response = await _apiClient.post('/planner/ai/productivity-insights');
    final data = response.data as Map<String, dynamic>;
    return ProductivityInsightModel.fromJson(data);
  }

  @override
  Future<DeadlineRiskModel> getDeadlineRiskAnalysis() async {
    final response = await _apiClient.post('/planner/ai/deadline-risk');
    final data = response.data as Map<String, dynamic>;
    return DeadlineRiskModel.fromJson(data);
  }

  @override
  Future<List<RecommendationModel>> getRecommendations() async {
    final response = await _apiClient.get('/planner/ai/recommendations');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => RecommendationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<AIHistoryModel>> getAIHistory() async {
    final response = await _apiClient.get('/planner/ai/history');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => AIHistoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<StudyPlanModel> savePlan(StudyPlanModel plan) async {
    final response = await _apiClient.post(
      '/planner/ai/saved-plans',
      data: plan.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return StudyPlanModel.fromJson(data);
  }

  @override
  Future<void> deletePlan(String planId) async {
    await _apiClient.delete('/planner/ai/saved-plans/$planId');
  }

  @override
  Future<void> deleteHistoryItem(String historyId) async {
    await _apiClient.delete('/planner/ai/history/$historyId');
  }
}
