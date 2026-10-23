import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/i_planner_repository.dart';

class SearchPlannerUseCase implements UseCase<List<TaskEntity>, String> {
  final IPlannerRepository repository;

  SearchPlannerUseCase(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(String params) async {
    return await repository.searchPlanner(params);
  }
}
