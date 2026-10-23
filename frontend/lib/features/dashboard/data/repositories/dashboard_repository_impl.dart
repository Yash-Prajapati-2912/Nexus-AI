import 'package:fpdart/fpdart.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ai_insight_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/entities/notification_summary_entity.dart';
import '../../domain/entities/planner_summary_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final IDashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DashboardEntity>> getDashboardSummary() async {
    try {
      final model = await _remoteDataSource.getDashboardSummary();
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlannerSummaryEntity>> getPlannerSummary() async {
    try {
      final model = await _remoteDataSource.getPlannerSummary();
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, FinanceSummaryEntity>> getFinanceSummary() async {
    try {
      final model = await _remoteDataSource.getFinanceSummary();
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, AiInsightEntity>> getAiInsights() async {
    try {
      final model = await _remoteDataSource.getAiInsights();
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, NotificationSummaryEntity>> getNotificationSummary() async {
    try {
      final model = await _remoteDataSource.getNotificationSummary();
      return Right(model.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
