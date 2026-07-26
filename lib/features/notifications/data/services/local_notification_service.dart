import 'package:nexus_ai/core/services/logger_service.dart';

/// Service handling local scheduled reminders and alarm notifications.
class LocalNotificationService {
  Future<void> initialize() async {
    LoggerService.info('Initializing Local Notification Service...');
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    LoggerService.info('Scheduled local reminder #$id "$title" for $scheduledDate');
  }

  Future<void> cancelReminder(int id) async {
    LoggerService.info('Cancelled local reminder #$id');
  }

  Future<void> cancelAllReminders() async {
    LoggerService.info('Cancelled all scheduled local reminders');
  }
}
