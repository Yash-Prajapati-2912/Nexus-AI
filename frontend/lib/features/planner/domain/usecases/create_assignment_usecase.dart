import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/assignment_entity.dart';
import '../repositories/i_planner_repository.dart';

class CreateAssignmentUseCase implements UseCase<AssignmentEntity, AssignmentEntity> {
  final IPlannerRepository repository;

  CreateAssignmentUseCase(this.repository);

  @override
  Future<Either<Failure, AssignmentEntity>> call(AssignmentEntity params) async {
    return await repository.createAssignment(params);
  }
}
