import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/i_planner_repository.dart';

class GetPlannerUseCase implements UseCase<List<TaskEntity>, NoParams> {
  final IPlannerRepository repository;

  GetPlannerUseCase(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) async {
    return await repository.getTasks();
  }
}
