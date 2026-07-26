import '../../domain/entities/notification_summary_entity.dart';

class NotificationSummaryItemModel {
  final String id;
  final String title;
  final String body;
  final String createdAt;

  const NotificationSummaryItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NotificationSummaryItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationSummaryItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt,
      };

  NotificationSummaryItem toDomain() {
    return NotificationSummaryItem(
      id: id,
      title: title,
      body: body,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}

class NotificationSummaryModel {
  final int unreadCount;
  final List<NotificationSummaryItemModel> recentNotifications;

  const NotificationSummaryModel({
    required this.unreadCount,
    required this.recentNotifications,
  });

  factory NotificationSummaryModel.fromJson(Map<String, dynamic> json) {
    final list = (json['recentNotifications'] as List<dynamic>?)
            ?.map((e) => NotificationSummaryItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return NotificationSummaryModel(
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      recentNotifications: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'unreadCount': unreadCount,
        'recentNotifications': recentNotifications.map((e) => e.toJson()).toList(),
      };

  NotificationSummaryEntity toDomain() {
    return NotificationSummaryEntity(
      unreadCount: unreadCount,
      recentNotifications: recentNotifications.map((e) => e.toDomain()).toList(),
    );
  }
}
