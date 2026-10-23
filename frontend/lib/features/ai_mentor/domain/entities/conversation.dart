import 'package:equatable/equatable.dart';
import 'chat_message.dart';

/// Domain entity representing an AI Mentor conversation session.
class Conversation extends Equatable {
  final String id;
  final String title;
  final bool isPinned;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final String lastMessageSnippet;
  final String topic; // GENERAL, STUDY, CAREER, FINANCE, PRODUCTIVITY, DECISION
  final List<ChatMessage> messages;

  const Conversation({
    required this.id,
    required this.title,
    this.isPinned = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    required this.lastMessageSnippet,
    required this.topic,
    this.messages = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        isPinned,
        isArchived,
        createdAt,
        updatedAt,
        messageCount,
        lastMessageSnippet,
        topic,
        messages,
      ];
}
