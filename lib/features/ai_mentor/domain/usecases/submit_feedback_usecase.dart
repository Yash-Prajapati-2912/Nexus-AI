import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/mentor_feedback.dart';
import '../repositories/i_ai_mentor_repository.dart';

class SubmitFeedbackUseCase implements UseCase<Unit, MentorFeedback> {
  final IAIMentorRepository repository;

  SubmitFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MentorFeedback feedback) {
    return repository.submitFeedback(feedback);
  }
}
