import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/i_ai_mentor_repository.dart';

class UpdateConversationParams extends Equatable {
  final String conversationId;
  final String? title;
  final bool? isPinned;
  final bool? isArchived;

  const UpdateConversationParams({required this.conversationId, this.title, this.isPinned, this.isArchived});

  @override
  List<Object?> get props => [conversationId, title, isPinned, isArchived];
}

class UpdateConversationUseCase implements UseCase<Conversation, UpdateConversationParams> {
  final IAIMentorRepository repository;

  UpdateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(UpdateConversationParams params) {
    return repository.updateConversation(params.conversationId, title: params.title, isPinned: params.isPinned, isArchived: params.isArchived);
  }
}
