import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/i_planner_repository.dart';

class UpdateTaskUseCase implements UseCase<TaskEntity, TaskEntity> {
  final IPlannerRepository repository;

  UpdateTaskUseCase(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(TaskEntity params) async {
    return await repository.updateTask(params);
  }
}
