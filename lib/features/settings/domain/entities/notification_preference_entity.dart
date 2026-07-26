import 'package:equatable/equatable.dart';

class NotificationPreferenceEntity extends Equatable {
  final bool pushNotifications;
  final bool inAppNotifications;
  final bool plannerNotifications;
  final bool financeNotifications;
  final bool aiNotifications;
  final bool reminderNotifications;
  final bool marketingNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;

  const NotificationPreferenceEntity({
    required this.pushNotifications,
    required this.inAppNotifications,
    required this.plannerNotifications,
    required this.financeNotifications,
    required this.aiNotifications,
    required this.reminderNotifications,
    required this.marketingNotifications,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.quietHoursEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
  });

  factory NotificationPreferenceEntity.initial() {
    return const NotificationPreferenceEntity(
      pushNotifications: true,
      inAppNotifications: true,
      plannerNotifications: true,
      financeNotifications: true,
      aiNotifications: true,
      reminderNotifications: true,
      marketingNotifications: false,
      soundEnabled: true,
      vibrationEnabled: true,
      quietHoursEnabled: false,
      quietHoursStart: '22:00',
      quietHoursEnd: '07:00',
    );
  }

  NotificationPreferenceEntity copyWith({
    bool? pushNotifications,
    bool? inAppNotifications,
    bool? plannerNotifications,
    bool? financeNotifications,
    bool? aiNotifications,
    bool? reminderNotifications,
    bool? marketingNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return NotificationPreferenceEntity(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      inAppNotifications: inAppNotifications ?? this.inAppNotifications,
      plannerNotifications: plannerNotifications ?? this.plannerNotifications,
      financeNotifications: financeNotifications ?? this.financeNotifications,
      aiNotifications: aiNotifications ?? this.aiNotifications,
      reminderNotifications: reminderNotifications ?? this.reminderNotifications,
      marketingNotifications: marketingNotifications ?? this.marketingNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  @override
  List<Object?> get props => [
        pushNotifications,
        inAppNotifications,
        plannerNotifications,
        financeNotifications,
        aiNotifications,
        reminderNotifications,
        marketingNotifications,
        soundEnabled,
        vibrationEnabled,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
      ];
}
