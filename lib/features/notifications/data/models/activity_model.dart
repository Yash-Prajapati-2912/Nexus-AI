import '../../domain/entities/activity_item.dart';

class ActivityModel extends ActivityItem {
  const ActivityModel({
    required super.id,
    required super.userId,
    required super.action,
    required super.module,
    required super.description,
    required super.timestamp,
    required super.icon,
    super.metadata,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      action: json['action'] as String? ?? 'ACTION',
      module: json['module'] as String? ?? 'SYSTEM',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      icon: json['icon'] as String? ?? 'history',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'action': action,
      'module': module,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'icon': icon,
      'metadata': metadata,
    };
  }
}
