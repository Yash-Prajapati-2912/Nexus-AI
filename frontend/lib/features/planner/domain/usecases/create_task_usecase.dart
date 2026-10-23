import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/i_planner_repository.dart';

class CreateTaskUseCase implements UseCase<TaskEntity, TaskEntity> {
  final IPlannerRepository repository;

  CreateTaskUseCase(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(TaskEntity params) async {
    return await repository.createTask(params);
  }
}
