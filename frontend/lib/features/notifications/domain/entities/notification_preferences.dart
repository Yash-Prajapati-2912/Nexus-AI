import 'package:equatable/equatable.dart';

/// Domain entity representing notification preferences and channels.
class NotificationPreferences extends Equatable {
  final bool pushEnabled;
  final bool inAppEnabled;
  final bool emailEnabled;
  final bool plannerAlerts;
  final bool financeAlerts;
  final bool aiAlerts;
  final bool quietHoursEnabled;
  final String quietHoursStart; // HH:mm format e.g. "22:00"
  final String quietHoursEnd;   // HH:mm format e.g. "07:00"
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.inAppEnabled = true,
    this.emailEnabled = true,
    this.plannerAlerts = true,
    this.financeAlerts = true,
    this.aiAlerts = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  @override
  List<Object?> get props => [
        pushEnabled,
        inAppEnabled,
        emailEnabled,
        plannerAlerts,
        financeAlerts,
        aiAlerts,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
        soundEnabled,
        vibrationEnabled,
      ];
}
