import 'dart:async';
import 'package:nexus_ai/core/services/logger_service.dart';

/// Service handling Firebase Cloud Messaging (FCM) Push Notifications.
class FCMPushNotificationService {
  final StreamController<Map<String, dynamic>> _onMessageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onMessage => _onMessageController.stream;

  Future<void> initialize() async {
    LoggerService.info('Initializing FCM Push Notification Service...');
  }

  Future<String?> getToken() async {
    LoggerService.info('Fetching FCM Device Token...');
    return 'fcm_mock_token_nexus_ai_2026';
  }

  void handleForegroundMessage(Map<String, dynamic> message) {
    LoggerService.info('Foreground Push Received: ${message["title"]}');
    _onMessageController.add(message);
  }

  void dispose() {
    _onMessageController.close();
  }
}
