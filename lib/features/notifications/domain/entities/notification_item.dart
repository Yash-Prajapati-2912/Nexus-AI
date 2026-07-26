import 'package:equatable/equatable.dart';

/// Domain entity representing an in-app or push notification.
class NotificationItem extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // PLANNER, FINANCE, AI_MENTOR, AI_PLANNER, AI_FINANCE, SYSTEM, SECURITY
  final String module; // PLANNER, FINANCE, MENTOR, PROFILE, SYSTEM
  final String category; // ASSIGNMENT, DEADLINE, BUDGET, SAVINGS, MENTOR_REPLY, SECURITY_ALERT
  final String priority; // HIGH, MEDIUM, LOW
  final bool isRead;
  final bool isArchived;
  final bool isPinned;
  final DateTime createdAt;
  final String? deepLinkUrl;
  final Map<String, dynamic>? metadata;

  const NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.module,
    required this.category,
    required this.priority,
    this.isRead = false,
    this.isArchived = false,
    this.isPinned = false,
    required this.createdAt,
    this.deepLinkUrl,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        module,
        category,
        priority,
        isRead,
        isArchived,
        isPinned,
        createdAt,
        deepLinkUrl,
        metadata,
      ];
}
