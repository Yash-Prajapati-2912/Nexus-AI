import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_finance/data/datasources/ai_finance_remote_data_source.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/ai_finance_history_item.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/budget_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/financial_health.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/forecast.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/goal_analysis.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/savings_recommendation.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/spending_insight.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/subscription_analysis.dart';
import 'package:nexus_ai/features/ai_finance/domain/repositories/i_ai_finance_repository.dart';

class AIFinanceRepositoryImpl implements IAIFinanceRepository {
  final IAIFinanceRemoteDataSource remoteDataSource;

  AIFinanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FinancialHealth>> getFinancialHealth() async {
    try {
      final model = await remoteDataSource.getFinancialHealth();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SpendingInsight>> getSpendingInsights() async {
    try {
      final model = await remoteDataSource.getSpendingInsights();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Forecast>> getForecast() async {
    try {
      final model = await remoteDataSource.getForecast();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BudgetRecommendation>> getBudgetRecommendations() async {
    try {
      final model = await remoteDataSource.getBudgetRecommendations();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingsRecommendation>> getSavingsAdvice() async {
    try {
      final model = await remoteDataSource.getSavingsAdvice();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SubscriptionAnalysis>> getSubscriptionAnalysis() async {
    try {
      final model = await remoteDataSource.getSubscriptionAnalysis();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<GoalAnalysis>>> getGoalAnalysis() async {
    try {
      final models = await remoteDataSource.getGoalAnalysis();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AIFinanceHistoryItem>>> getAIHistory() async {
    try {
      final models = await remoteDataSource.getAIHistory();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveReport(String reportId) async {
    try {
      await remoteDataSource.saveReport(reportId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReport(String reportId) async {
    try {
      await remoteDataSource.deleteReport(reportId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
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
