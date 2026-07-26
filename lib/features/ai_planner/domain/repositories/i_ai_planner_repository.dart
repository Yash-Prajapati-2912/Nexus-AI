import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/ai_history_item.dart';

import '../entities/deadline_risk.dart';
import '../entities/priority_optimizer.dart';
import '../entities/productivity_insight.dart';
import '../entities/recommendation.dart';
import '../entities/study_plan.dart';
import '../entities/workload_analysis.dart';

abstract class IAIPlannerRepository {
  Future<Either<Failure, StudyPlan>> generateStudyPlan({
    required String timeframe,
    List<String>? targetSubjects,
    int? dailyGoalMinutes,
  });

  Future<Either<Failure, PriorityOptimizer>> prioritizeTasks({
    List<String>? taskIds,
  });

  Future<Either<Failure, WorkloadAnalysis>> getWorkloadAnalysis();

  Future<Either<Failure, ProductivityInsight>> getProductivityInsights();

  Future<Either<Failure, DeadlineRisk>> getDeadlineRiskAnalysis();

  Future<Either<Failure, List<Recommendation>>> getRecommendations();

  Future<Either<Failure, List<AIHistoryItem>>> getAIHistory();

  Future<Either<Failure, StudyPlan>> savePlan(StudyPlan plan);

  Future<Either<Failure, Unit>> deletePlan(String planId);

  Future<Either<Failure, Unit>> deleteHistoryItem(String historyId);
}
