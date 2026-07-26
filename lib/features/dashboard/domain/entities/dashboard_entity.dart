import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import 'ai_insight_entity.dart';
import 'chart_data_entity.dart';
import 'finance_summary_entity.dart';
import 'notification_summary_entity.dart';
import 'planner_summary_entity.dart';
import 'productivity_stats_entity.dart';

class DashboardEntity extends Equatable {
  final UserEntity user;
  final PlannerSummaryEntity plannerSummary;
  final FinanceSummaryEntity financeSummary;
  final AiInsightEntity aiInsight;
  final NotificationSummaryEntity notificationSummary;
  final ProductivityStatsEntity productivityStats;
  final ChartDataEntity chartData;

  const DashboardEntity({
    required this.user,
    required this.plannerSummary,
    required this.financeSummary,
    required this.aiInsight,
    required this.notificationSummary,
    required this.productivityStats,
    required this.chartData,
  });

  @override
  List<Object?> get props => [
        user,
        plannerSummary,
        financeSummary,
        aiInsight,
        notificationSummary,
        productivityStats,
        chartData,
      ];
}
