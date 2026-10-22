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

    // Map backend messageId while retaining compatibility with id
    final id = (json['messageId'] ?? json['id']) as String? ?? '';

    final conversationId = json['conversationId'] as String? ?? '';

    // Sender resolution: Role ('USER' vs 'ASSISTANT') or sender ('USER' vs 'AI')
    final rawRole = (json['role'] ?? json['sender']) as String?;
    final String sender;
    if (rawRole != null && (rawRole.toUpperCase() == 'USER' || rawRole.toUpperCase() == 'STUDENT')) {
      sender = 'USER';
    } else {
      sender = 'AI';
    }

    // Map assistant summary to displayed message content, retaining existing aliases
    String content = '';
    final rawSummary = json['summary'] as String?;
    final rawContent = json['content'] as String?;
    final rawText = json['text'] as String?;
    final rawResponse = json['response'] as String?;
    final rawUserMessage = json['userMessage'] as String?;

    if (rawSummary != null && rawSummary.isNotEmpty) {
      final buffer = StringBuffer(rawSummary);

      final recs = json['recommendations'] as List<dynamic>?;
      if (recs != null && recs.isNotEmpty) {
        buffer.writeln('\n\n### Recommendations');
        for (final r in recs) {
          if (r is Map<String, dynamic>) {
            final title = r['title'] ?? '';
            final desc = r['description'] ?? '';
            buffer.writeln('- **$title**: $desc');
          }
        }
      }

      final plan = json['actionPlan'] as List<dynamic>?;
      if (plan != null && plan.isNotEmpty) {
        buffer.writeln('\n\n### Action Plan');
        for (final a in plan) {
          if (a is Map<String, dynamic>) {
            final step = a['step'] ?? '';
            final title = a['title'] ?? '';
            final desc = a['description'] ?? '';
            buffer.writeln('$step. **$title** — $desc');
          }
        }
      }

      content = buffer.toString().trim();
    } else if (rawContent != null && rawContent.isNotEmpty) {
      content = rawContent;
    } else if (rawText != null && rawText.isNotEmpty) {
      content = rawText;
    } else if (rawResponse != null && rawResponse.isNotEmpty) {
      content = rawResponse;
    } else if (sender == 'USER' && rawUserMessage != null && rawUserMessage.isNotEmpty) {
      content = rawUserMessage;
    } else if (json['aiResponse'] is Map<String, dynamic>) {
      final aiResp = json['aiResponse'] as Map<String, dynamic>;
      final aiSummary = (aiResp['summary'] ?? aiResp['content'] ?? aiResp['text'] ?? '') as String;
      final buffer = StringBuffer(aiSummary);

      final recs = aiResp['recommendations'] as List<dynamic>?;
      if (recs != null && recs.isNotEmpty) {
        buffer.writeln('\n\n### Recommendations');
        for (final r in recs) {
          if (r is Map<String, dynamic>) {
            final title = r['title'] ?? '';
            final desc = r['description'] ?? '';
            buffer.writeln('- **$title**: $desc');
          }
        }
      }

      final plan = aiResp['actionPlan'] as List<dynamic>?;
      if (plan != null && plan.isNotEmpty) {
        buffer.writeln('\n\n### Action Plan');
        for (final a in plan) {
          if (a is Map<String, dynamic>) {
            final step = a['step'] ?? '';
            final title = a['title'] ?? '';
            final desc = a['description'] ?? '';
            buffer.writeln('$step. **$title** — $desc');
          }
        }
      }
      content = buffer.toString().trim();
    } else if (rawUserMessage != null) {
      content = rawUserMessage;
    }

    return ChatMessageModel(
      id: id,
      conversationId: conversationId,
      sender: sender,
      content: content,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
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
