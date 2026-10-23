import '../../domain/entities/notification_preferences.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    super.pushEnabled,
    super.inAppEnabled,
    super.emailEnabled,
    super.plannerAlerts,
    super.financeAlerts,
    super.aiAlerts,
    super.quietHoursEnabled,
    super.quietHoursStart,
    super.quietHoursEnd,
    super.soundEnabled,
    super.vibrationEnabled,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      pushEnabled: json['pushEnabled'] as bool? ?? json['push'] as bool? ?? true,
      inAppEnabled: json['inAppEnabled'] as bool? ?? json['inApp'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? json['email'] as bool? ?? true,
      plannerAlerts: json['plannerAlerts'] as bool? ?? true,
      financeAlerts: json['financeAlerts'] as bool? ?? true,
      aiAlerts: json['aiAlerts'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'inAppEnabled': inAppEnabled,
      'emailEnabled': emailEnabled,
      'plannerAlerts': plannerAlerts,
      'financeAlerts': financeAlerts,
      'aiAlerts': aiAlerts,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }
}
