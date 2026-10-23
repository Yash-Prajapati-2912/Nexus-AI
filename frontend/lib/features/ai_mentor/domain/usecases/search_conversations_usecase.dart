import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/i_ai_mentor_repository.dart';

class SearchConversationsUseCase implements UseCase<List<Conversation>, String> {
  final IAIMentorRepository repository;

  SearchConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(String query) {
    return repository.searchConversations(query);
  }
}
