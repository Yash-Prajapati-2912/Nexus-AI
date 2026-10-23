import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_planner/data/datasources/ai_planner_remote_data_source.dart';
import 'package:nexus_ai/features/ai_planner/data/models/study_plan_model.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/ai_history_item.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/deadline_risk.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/priority_optimizer.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/productivity_insight.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/recommendation.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/study_plan.dart';
import 'package:nexus_ai/features/ai_planner/domain/entities/workload_analysis.dart';
import 'package:nexus_ai/features/ai_planner/domain/repositories/i_ai_planner_repository.dart';

class AIPlannerRepositoryImpl implements IAIPlannerRepository {
  final IAIPlannerRemoteDataSource remoteDataSource;

  AIPlannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudyPlan>> generateStudyPlan({
    required String timeframe,
    List<String>? targetSubjects,
    int? dailyGoalMinutes,
  }) async {
    try {
      final model = await remoteDataSource.generateStudyPlan(
        timeframe: timeframe,
        targetSubjects: targetSubjects,
        dailyGoalMinutes: dailyGoalMinutes,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PriorityOptimizer>> prioritizeTasks({
    List<String>? taskIds,
  }) async {
    try {
      final model = await remoteDataSource.prioritizeTasks(taskIds: taskIds);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, WorkloadAnalysis>> getWorkloadAnalysis() async {
    try {
      final model = await remoteDataSource.getWorkloadAnalysis();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductivityInsight>> getProductivityInsights() async {
    try {
      final model = await remoteDataSource.getProductivityInsights();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DeadlineRisk>> getDeadlineRiskAnalysis() async {
    try {
      final model = await remoteDataSource.getDeadlineRiskAnalysis();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendations() async {
    try {
      final models = await remoteDataSource.getRecommendations();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AIHistoryItem>>> getAIHistory() async {
    try {
      final models = await remoteDataSource.getAIHistory();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StudyPlan>> savePlan(StudyPlan plan) async {
    try {
      final model = StudyPlanModel.fromEntity(plan);
      final savedModel = await remoteDataSource.savePlan(model);
      return Right(savedModel);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePlan(String planId) async {
    try {
      await remoteDataSource.deletePlan(planId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHistoryItem(String historyId) async {
    try {
      await remoteDataSource.deleteHistoryItem(historyId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is TimeoutException) {
      return TimeoutFailure(message: e.message);
    } else if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message});
}
