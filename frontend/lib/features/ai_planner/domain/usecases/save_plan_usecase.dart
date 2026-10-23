import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/study_plan.dart';
import '../repositories/i_ai_planner_repository.dart';

class SavePlanUseCase implements UseCase<StudyPlan, StudyPlan> {
  final IAIPlannerRepository repository;

  SavePlanUseCase(this.repository);

  @override
  Future<Either<Failure, StudyPlan>> call(StudyPlan plan) {
    return repository.savePlan(plan);
  }
}
