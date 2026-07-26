import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/i_ai_mentor_repository.dart';

class LoadConversationsUseCase implements UseCase<List<Conversation>, NoParams> {
  final IAIMentorRepository repository;

  LoadConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(NoParams params) {
    return repository.getConversations();
  }
}
