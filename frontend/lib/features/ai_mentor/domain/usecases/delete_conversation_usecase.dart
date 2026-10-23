import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../repositories/i_ai_mentor_repository.dart';

class DeleteConversationUseCase implements UseCase<Unit, String> {
  final IAIMentorRepository repository;

  DeleteConversationUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String conversationId) {
    return repository.deleteConversation(conversationId);
  }
}
