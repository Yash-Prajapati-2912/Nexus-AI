import '../../domain/entities/notification_preference_entity.dart';

class NotificationPreferenceModel extends NotificationPreferenceEntity {
  const NotificationPreferenceModel({
    required super.pushNotifications,
    required super.inAppNotifications,
    required super.plannerNotifications,
    required super.financeNotifications,
    required super.aiNotifications,
    required super.reminderNotifications,
    required super.marketingNotifications,
    required super.soundEnabled,
    required super.vibrationEnabled,
    required super.quietHoursEnabled,
    required super.quietHoursStart,
    required super.quietHoursEnd,
  });

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceModel(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      inAppNotifications: json['inAppNotifications'] as bool? ?? true,
      plannerNotifications: json['plannerNotifications'] as bool? ?? true,
      financeNotifications: json['financeNotifications'] as bool? ?? true,
      aiNotifications: json['aiNotifications'] as bool? ?? true,
      reminderNotifications: json['reminderNotifications'] as bool? ?? true,
      marketingNotifications: json['marketingNotifications'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'inAppNotifications': inAppNotifications,
      'plannerNotifications': plannerNotifications,
      'financeNotifications': financeNotifications,
      'aiNotifications': aiNotifications,
      'reminderNotifications': reminderNotifications,
      'marketingNotifications': marketingNotifications,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }

  factory NotificationPreferenceModel.fromEntity(NotificationPreferenceEntity entity) {
    return NotificationPreferenceModel(
      pushNotifications: entity.pushNotifications,
      inAppNotifications: entity.inAppNotifications,
      plannerNotifications: entity.plannerNotifications,
      financeNotifications: entity.financeNotifications,
      aiNotifications: entity.aiNotifications,
      reminderNotifications: entity.reminderNotifications,
      marketingNotifications: entity.marketingNotifications,
      soundEnabled: entity.soundEnabled,
      vibrationEnabled: entity.vibrationEnabled,
      quietHoursEnabled: entity.quietHoursEnabled,
      quietHoursStart: entity.quietHoursStart,
      quietHoursEnd: entity.quietHoursEnd,
    );
  }
}
