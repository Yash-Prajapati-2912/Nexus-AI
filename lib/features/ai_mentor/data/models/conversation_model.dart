import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.title,
    super.isPinned,
    super.isArchived,
    required super.createdAt,
    required super.updatedAt,
    required super.messageCount,
    required super.lastMessageSnippet,
    required super.topic,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Conversation',
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
      messageCount: json['messageCount'] as int? ?? (json['messages'] is List ? (json['messages'] as List).length : 0),
      lastMessageSnippet: json['lastMessageSnippet'] as String? ?? json['snippet'] as String? ?? 'No messages yet.',
      topic: json['topic'] as String? ?? 'GENERAL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messageCount': messageCount,
      'lastMessageSnippet': lastMessageSnippet,
      'topic': topic,
    };
  }
}
