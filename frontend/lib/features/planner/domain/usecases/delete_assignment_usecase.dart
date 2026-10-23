import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_planner_repository.dart';

class DeleteAssignmentUseCase implements UseCase<void, String> {
  final IPlannerRepository repository;

  DeleteAssignmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteAssignment(params);
  }
}
