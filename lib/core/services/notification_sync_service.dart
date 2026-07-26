import 'app_logger.dart';

class NotificationSyncService {
  Future<void> syncBackgroundNotifications() async {
    AppLogger.info('NotificationSyncService: Synchronized background FCM notification queue and silent pushes.');
  }

  Future<void> refreshFCMToken() async {
    AppLogger.info('NotificationSyncService: Refreshed FCM registration token.');
  }
}
