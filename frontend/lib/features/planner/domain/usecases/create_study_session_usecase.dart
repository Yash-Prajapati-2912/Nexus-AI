import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/study_session_entity.dart';
import '../repositories/i_planner_repository.dart';

class CreateStudySessionUseCase implements UseCase<StudySessionEntity, StudySessionEntity> {
  final IPlannerRepository repository;

  CreateStudySessionUseCase(this.repository);

  @override
  Future<Either<Failure, StudySessionEntity>> call(StudySessionEntity params) async {
    return await repository.createStudySession(params);
  }
}
