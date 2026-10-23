import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/chat_message.dart';
import '../entities/conversation.dart';
import '../entities/mentor_feedback.dart';
import '../entities/prompt_template.dart';
import '../entities/student_wellness.dart';

abstract class IAIMentorRepository {
  Future<Either<Failure, ChatMessage>> sendMessage(String conversationId, String content, {String? topic});
  Future<Either<Failure, List<Conversation>>> getConversations({int page = 1, int limit = 20});
  Future<Either<Failure, Conversation>> getConversationById(String conversationId);
  Future<Either<Failure, Conversation>> updateConversation(String conversationId, {String? title, bool? isPinned, bool? isArchived});
  Future<Either<Failure, Unit>> deleteConversation(String conversationId);
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId);
  Future<Either<Failure, Unit>> submitFeedback(MentorFeedback feedback);
  Future<Either<Failure, StudentWellness>> getWellnessScores();
  Future<Either<Failure, List<PromptTemplate>>> getSuggestedPrompts();
  Future<Either<Failure, List<Conversation>>> searchConversations(String query);
}
