import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/study_plan.dart';
import '../repositories/i_ai_planner_repository.dart';

class GenerateStudyPlanParams extends Equatable {
  final String timeframe;
  final List<String>? targetSubjects;
  final int? dailyGoalMinutes;

  const GenerateStudyPlanParams({
    required this.timeframe,
    this.targetSubjects,
    this.dailyGoalMinutes,
  });

  @override
  List<Object?> get props => [timeframe, targetSubjects, dailyGoalMinutes];
}

class GenerateStudyPlanUseCase implements UseCase<StudyPlan, GenerateStudyPlanParams> {
  final IAIPlannerRepository repository;

  GenerateStudyPlanUseCase(this.repository);

  @override
  Future<Either<Failure, StudyPlan>> call(GenerateStudyPlanParams params) {
    return repository.generateStudyPlan(
      timeframe: params.timeframe,
      targetSubjects: params.targetSubjects,
      dailyGoalMinutes: params.dailyGoalMinutes,
    );
  }
}
