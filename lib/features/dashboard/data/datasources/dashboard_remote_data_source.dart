import '../../../../config/constants/api_constants.dart';
import '../../../../core/network/base_remote_data_source.dart';
import '../models/ai_insight_model.dart';
import '../models/dashboard_model.dart';
import '../models/finance_summary_model.dart';
import '../models/notification_summary_model.dart';
import '../models/planner_summary_model.dart';

abstract class IDashboardRemoteDataSource {
  Future<DashboardModel> getDashboardSummary();
  Future<PlannerSummaryModel> getPlannerSummary();
  Future<FinanceSummaryModel> getFinanceSummary();
  Future<AiInsightModel> getAiInsights();
  Future<NotificationSummaryModel> getNotificationSummary();
}

class DashboardRemoteDataSourceImpl extends BaseRemoteDataSource implements IDashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(super.apiClient);

  @override
  Future<DashboardModel> getDashboardSummary() async {
    final response = await apiClient.get(ApiConstants.dashboardSummary);
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return DashboardModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PlannerSummaryModel> getPlannerSummary() async {
    final response = await apiClient.get(ApiConstants.plannerSummary);
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return PlannerSummaryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<FinanceSummaryModel> getFinanceSummary() async {
    final response = await apiClient.get(ApiConstants.financeSummary);
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return FinanceSummaryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<AiInsightModel> getAiInsights() async {
    final response = await apiClient.get(ApiConstants.dashboardInsights);
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return AiInsightModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<NotificationSummaryModel> getNotificationSummary() async {
    final response = await apiClient.get(ApiConstants.notifications);
    final data = (response.data is Map<String, dynamic> && response.data['data'] != null)
        ? response.data['data']
        : response.data;
    return NotificationSummaryModel.fromJson(data as Map<String, dynamic>);
  }
}
