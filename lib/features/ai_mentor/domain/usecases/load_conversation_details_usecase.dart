import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/i_ai_mentor_repository.dart';

class LoadConversationDetailsUseCase implements UseCase<Conversation, String> {
  final IAIMentorRepository repository;

  LoadConversationDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(String conversationId) {
    return repository.getConversationById(conversationId);
  }
}
