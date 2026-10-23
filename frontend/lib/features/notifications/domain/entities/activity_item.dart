import 'package:equatable/equatable.dart';

/// Domain entity representing an activity log entry in the Activity Center.
class ActivityItem extends Equatable {
  final String id;
  final String userId;
  final String action;
  final String module; // PLANNER, FINANCE, AI_MENTOR, PROFILE, SYSTEM
  final String description;
  final DateTime timestamp;
  final String icon;
  final Map<String, dynamic>? metadata;

  const ActivityItem({
    required this.id,
    required this.userId,
    required this.action,
    required this.module,
    required this.description,
    required this.timestamp,
    required this.icon,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        action,
        module,
        description,
        timestamp,
        icon,
        metadata,
      ];
}
