import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:nexus_ai/features/notifications/domain/entities/activity_item.dart';
import 'package:nexus_ai/features/notifications/domain/entities/notification_item.dart';
import 'package:nexus_ai/features/notifications/domain/entities/notification_preferences.dart';
import 'package:nexus_ai/features/notifications/domain/repositories/i_notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications({int page = 1, int limit = 20}) async {
    try {
      final list = await remoteDataSource.getNotifications(page: page, limit: limit);
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() async {
    try {
      final prefs = await remoteDataSource.getPreferences();
      return Right(prefs);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(Map<String, dynamic> body) async {
    try {
      final prefs = await remoteDataSource.updatePreferences(body);
      return Right(prefs);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> registerDeviceToken(String deviceId, String token, String platform) async {
    try {
      await remoteDataSource.registerDeviceToken(deviceId, token, platform);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ActivityItem>>> getActivityTimeline() async {
    try {
      final list = await remoteDataSource.getActivityTimeline();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}
