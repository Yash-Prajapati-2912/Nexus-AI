import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/ai_insight_entity.dart';
import '../entities/dashboard_entity.dart';
import '../entities/finance_summary_entity.dart';
import '../entities/notification_summary_entity.dart';
import '../entities/planner_summary_entity.dart';

abstract class IDashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboardSummary();
  Future<Either<Failure, PlannerSummaryEntity>> getPlannerSummary();
  Future<Either<Failure, FinanceSummaryEntity>> getFinanceSummary();
  Future<Either<Failure, AiInsightEntity>> getAiInsights();
  Future<Either<Failure, NotificationSummaryEntity>> getNotificationSummary();
}
