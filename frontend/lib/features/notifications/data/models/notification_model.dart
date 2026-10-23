import '../../domain/entities/notification_item.dart';

class NotificationModel extends NotificationItem {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    required super.module,
    required super.category,
    required super.priority,
    super.isRead,
    super.isArchived,
    super.isPinned,
    required super.createdAt,
    super.deepLinkUrl,
    super.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? json['subject'] as String? ?? 'Notification',
      body: json['body'] as String? ?? json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'SYSTEM',
      module: json['module'] as String? ?? 'SYSTEM',
      category: json['category'] as String? ?? 'GENERAL',
      priority: json['priority'] as String? ?? 'MEDIUM',
      isRead: json['isRead'] as bool? ?? json['read'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      deepLinkUrl: json['deepLinkUrl'] as String? ?? json['link'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'module': module,
      'category': category,
      'priority': priority,
      'isRead': isRead,
      'isArchived': isArchived,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'deepLinkUrl': deepLinkUrl,
      'metadata': metadata,
    };
  }
}
