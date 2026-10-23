import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/dashboard_entity.dart';
import 'ai_insight_model.dart';
import 'chart_data_model.dart';
import 'finance_summary_model.dart';
import 'notification_summary_model.dart';
import 'planner_summary_model.dart';
import 'productivity_stats_model.dart';

class DashboardModel {
  final UserModel user;
  final PlannerSummaryModel plannerSummary;
  final FinanceSummaryModel financeSummary;
  final AiInsightModel aiInsight;
  final NotificationSummaryModel notificationSummary;
  final ProductivityStatsModel productivityStats;
  final ChartDataModel chartData;

  const DashboardModel({
    required this.user,
    required this.plannerSummary,
    required this.financeSummary,
    required this.aiInsight,
    required this.notificationSummary,
    required this.productivityStats,
    required this.chartData,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      plannerSummary: PlannerSummaryModel.fromJson(
        (json['plannerOverview'] ?? json['plannerSummary']) as Map<String, dynamic>? ?? {},
      ),
      financeSummary: FinanceSummaryModel.fromJson(
        (json['financeOverview'] ?? json['financeSummary']) as Map<String, dynamic>? ?? {},
      ),
      aiInsight: AiInsightModel.fromJson(
        (json['aiInsightsOverview'] ?? json['aiInsight']) as Map<String, dynamic>? ?? {},
      ),
      notificationSummary: NotificationSummaryModel.fromJson(
        (json['notificationSummary'] ?? json['notifications']) as Map<String, dynamic>? ?? {},
      ),
      productivityStats: ProductivityStatsModel.fromJson(
        (json['productivityStats'] ?? json['productivity']) as Map<String, dynamic>? ?? {},
      ),
      chartData: ChartDataModel.fromJson(
        (json['chartData'] ?? json['charts']) as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'plannerSummary': plannerSummary.toJson(),
        'financeSummary': financeSummary.toJson(),
        'aiInsight': aiInsight.toJson(),
        'notificationSummary': notificationSummary.toJson(),
        'productivityStats': productivityStats.toJson(),
        'chartData': chartData.toJson(),
      };

  DashboardEntity toDomain() {
    return DashboardEntity(
      user: user.toDomain(),
      plannerSummary: plannerSummary.toDomain(),
      financeSummary: financeSummary.toDomain(),
      aiInsight: aiInsight.toDomain(),
      notificationSummary: notificationSummary.toDomain(),
      productivityStats: productivityStats.toDomain(),
      chartData: chartData.toDomain(),
    );
  }
}
