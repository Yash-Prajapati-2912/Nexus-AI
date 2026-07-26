import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'logger_service.dart';

/// Push & Local Notification Service Infrastructure.
class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService({FlutterLocalNotificationsPlugin? localNotifications})
      : _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        LoggerService.info('Notification response payload: ${response.payload}');
      },
    );

    LoggerService.info('Notification Service initialized.');
  }

  Future<bool> requestPermissions() async {
    final androidImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await androidImplementation?.requestNotificationsPermission() ?? false;

    final iosImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final iosGranted =
        await iosImplementation?.requestPermissions(alert: true, badge: true, sound: true) ?? false;

    return androidGranted || iosGranted;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'nexus_default_channel',
      'General Notifications',
      channelDescription: 'Default notification channel for Nexus AI',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }
}
