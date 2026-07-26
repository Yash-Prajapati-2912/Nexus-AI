import 'package:equatable/equatable.dart';

class NotificationSummaryItem extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  const NotificationSummaryItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt];
}

class NotificationSummaryEntity extends Equatable {
  final int unreadCount;
  final List<NotificationSummaryItem> recentNotifications;

  const NotificationSummaryEntity({
    required this.unreadCount,
    required this.recentNotifications,
  });

  @override
  List<Object?> get props => [unreadCount, recentNotifications];
}
