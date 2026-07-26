import '../../domain/entities/chat_message.dart';
import 'chat_attachment_model.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.sender,
    required super.content,
    required super.createdAt,
    super.isBookmarked,
    super.rating,
    super.feedbackText,
    super.attachments,
    super.contextSnippet,
    super.sources,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final rawAtts = json['attachments'] as List<dynamic>? ?? [];
    final atts = rawAtts
        .map((e) => ChatAttachmentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawSources = json['sources'] as List<dynamic>? ?? [];
    final sourcesList = rawSources.map((e) => e.toString()).toList();

    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      sender: json['sender'] as String? ?? json['role'] as String? ?? 'AI',
      content: json['content'] as String? ?? json['text'] as String? ?? json['response'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      rating: json['rating'] as int?,
      feedbackText: json['feedbackText'] as String?,
      attachments: atts,
      contextSnippet: json['contextSnippet'] as String?,
      sources: sourcesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'sender': sender,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isBookmarked': isBookmarked,
      'rating': rating,
      'feedbackText': feedbackText,
      'attachments': attachments
          .map((e) => ChatAttachmentModel(
                id: e.id,
                fileName: e.fileName,
                fileType: e.fileType,
                fileUrl: e.fileUrl,
                localPath: e.localPath,
                fileSize: e.fileSize,
              ).toJson())
          .toList(),
      'contextSnippet': contextSnippet,
      'sources': sources,
    };
  }
}
