import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_mentor/data/datasources/ai_mentor_remote_data_source.dart';
import 'package:nexus_ai/features/ai_mentor/data/models/mentor_feedback_model.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/chat_message.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/conversation.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/mentor_feedback.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/prompt_template.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/student_wellness.dart';
import 'package:nexus_ai/features/ai_mentor/domain/repositories/i_ai_mentor_repository.dart';

class AIMentorRepositoryImpl implements IAIMentorRepository {
  final IAIMentorRemoteDataSource remoteDataSource;

  AIMentorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(String conversationId, String content, {String? topic}) async {
    try {
      final msg = await remoteDataSource.sendMessage(conversationId, content, topic: topic);
      return Right(msg);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversations({int page = 1, int limit = 20}) async {
    try {
      final list = await remoteDataSource.getConversations(page: page, limit: limit);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Conversation>> getConversationById(String conversationId) async {
    try {
      final conv = await remoteDataSource.getConversationById(conversationId);
      return Right(conv);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Conversation>> updateConversation(String conversationId, {String? title, bool? isPinned, bool? isArchived}) async {
    try {
      final conv = await remoteDataSource.updateConversation(conversationId, title: title, isPinned: isPinned, isArchived: isArchived);
      return Right(conv);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteConversation(String conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId) async {
    try {
      final list = await remoteDataSource.getMessages(conversationId);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitFeedback(MentorFeedback feedback) async {
    try {
      final model = MentorFeedbackModel(
        messageId: feedback.messageId,
        rating: feedback.rating,
        feedbackType: feedback.feedbackType,
        comment: feedback.comment,
        category: feedback.category,
      );
      await remoteDataSource.submitFeedback(model);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StudentWellness>> getWellnessScores() async {
    try {
      final scores = await remoteDataSource.getWellnessScores();
      return Right(scores);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PromptTemplate>>> getSuggestedPrompts() async {
    try {
      final list = await remoteDataSource.getSuggestedPrompts();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> searchConversations(String query) async {
    try {
      final list = await remoteDataSource.searchConversations(query);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}
