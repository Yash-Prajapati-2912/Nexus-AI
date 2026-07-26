import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/student_wellness.dart';
import '../repositories/i_ai_mentor_repository.dart';

class GetWellnessScoresUseCase implements UseCase<StudentWellness, NoParams> {
  final IAIMentorRepository repository;

  GetWellnessScoresUseCase(this.repository);

  @override
  Future<Either<Failure, StudentWellness>> call(NoParams params) {
    return repository.getWellnessScores();
  }
}
