import '../../domain/entities/conversation.dart';
import 'chat_message_model.dart';

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
    super.messages,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final convId = json['id'] as String? ?? '';
    final rawMsgs = json['messages'] as List<dynamic>? ?? [];
    final parsedMsgs = rawMsgs.map((e) {
      final map = Map<String, dynamic>.from(e as Map<String, dynamic>);
      if (!map.containsKey('conversationId') ||
          map['conversationId'] == null ||
          (map['conversationId'] as String).isEmpty) {
        map['conversationId'] = convId;
      }
      return ChatMessageModel.fromJson(map);
    }).toList();

    return ConversationModel(
      id: convId,
      title: json['title'] as String? ?? 'Conversation',
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt'] as DateTime
              : DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is DateTime
              ? json['updatedAt'] as DateTime
              : DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      messageCount: json['messageCount'] as int? ??
          (parsedMsgs.isNotEmpty
              ? parsedMsgs.length
              : (json['messages'] is List ? (json['messages'] as List).length : 0)),
      lastMessageSnippet: json['lastMessageSnippet'] as String? ??
          json['snippet'] as String? ??
          (parsedMsgs.isNotEmpty ? parsedMsgs.last.content : 'No messages yet.'),
      topic: json['topic'] as String? ?? json['conversationType'] as String? ?? 'GENERAL',
      messages: parsedMsgs,
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
      'messages': messages.map((m) {
        if (m is ChatMessageModel) return m.toJson();
        return ChatMessageModel(
          id: m.id,
          conversationId: m.conversationId,
          sender: m.sender,
          content: m.content,
          createdAt: m.createdAt,
          isBookmarked: m.isBookmarked,
          rating: m.rating,
          feedbackText: m.feedbackText,
          attachments: m.attachments,
          contextSnippet: m.contextSnippet,
          sources: m.sources,
        ).toJson();
      }).toList(),
    };
  }
}
