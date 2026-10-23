import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/i_planner_repository.dart';

class CompleteTaskUseCase implements UseCase<TaskEntity, String> {
  final IPlannerRepository repository;

  CompleteTaskUseCase(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(String params) async {
    return await repository.completeTask(params);
  }
}
