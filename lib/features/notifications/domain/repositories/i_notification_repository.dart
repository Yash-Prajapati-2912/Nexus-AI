import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/activity_item.dart';
import '../entities/notification_item.dart';
import '../entities/notification_preferences.dart';

abstract class INotificationRepository {
  Future<Either<Failure, List<NotificationItem>>> getNotifications({int page = 1, int limit = 20});
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, Unit>> markAsRead(String notificationId);
  Future<Either<Failure, Unit>> markAllAsRead();
  Future<Either<Failure, Unit>> deleteNotification(String notificationId);
  Future<Either<Failure, NotificationPreferences>> getPreferences();
  Future<Either<Failure, NotificationPreferences>> updatePreferences(Map<String, dynamic> body);
  Future<Either<Failure, Unit>> registerDeviceToken(String deviceId, String token, String platform);
  Future<Either<Failure, List<ActivityItem>>> getActivityTimeline();
}
