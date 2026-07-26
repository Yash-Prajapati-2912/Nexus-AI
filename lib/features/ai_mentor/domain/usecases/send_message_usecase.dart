import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/i_ai_mentor_repository.dart';

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;
  final String? topic;

  const SendMessageParams({required this.conversationId, required this.content, this.topic});

  @override
  List<Object?> get props => [conversationId, content, topic];
}

class SendMessageUseCase implements UseCase<ChatMessage, SendMessageParams> {
  final IAIMentorRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, ChatMessage>> call(SendMessageParams params) {
    return repository.sendMessage(params.conversationId, params.content, topic: params.topic);
  }
}
