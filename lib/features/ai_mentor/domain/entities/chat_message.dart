import 'package:equatable/equatable.dart';
import 'chat_attachment.dart';

/// Domain entity representing a single chat message in AI Mentor.
class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String sender; // USER or AI
  final String content;
  final DateTime createdAt;
  final bool isBookmarked;
  final int? rating; // 1 to 5
  final String? feedbackText;
  final List<ChatAttachment> attachments;
  final String? contextSnippet;
  final List<String> sources;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.isBookmarked = false,
    this.rating,
    this.feedbackText,
    this.attachments = const [],
    this.contextSnippet,
    this.sources = const [],
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        sender,
        content,
        createdAt,
        isBookmarked,
        rating,
        feedbackText,
        attachments,
        contextSnippet,
        sources,
      ];
}
