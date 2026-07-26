import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_ai_planner_repository.dart';

class DeletePlanUseCase implements UseCase<Unit, String> {
  final IAIPlannerRepository repository;

  DeletePlanUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String planId) {
    return repository.deletePlan(planId);
  }
}
