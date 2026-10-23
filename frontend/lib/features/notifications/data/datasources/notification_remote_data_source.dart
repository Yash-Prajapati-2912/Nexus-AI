import 'package:nexus_ai/core/network/api_client.dart';
import '../models/activity_model.dart';
import '../models/notification_model.dart';
import '../models/notification_preferences_model.dart';

abstract class INotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<NotificationPreferencesModel> getPreferences();
  Future<NotificationPreferencesModel> updatePreferences(Map<String, dynamic> body);
  Future<void> registerDeviceToken(String deviceId, String token, String platform);
  Future<List<ActivityModel>> getActivityTimeline();
}

class NotificationRemoteDataSourceImpl implements INotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '/notifications',
      queryParameters: {'page': page, 'limit': limit},
    );
    final rawData = response.data;
    List<dynamic> list = [];
    if (rawData is List<dynamic>) {
      list = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['data'] is List<dynamic>) {
      list = rawData['data'] as List<dynamic>;
    }
    return list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get('/notifications/unread');
    final data = response.data as Map<String, dynamic>;
    return data['unreadCount'] as int? ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.patch('/notifications/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch('/notifications/read-all');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _apiClient.delete('/notifications/$notificationId');
  }

  @override
  Future<NotificationPreferencesModel> getPreferences() async {
    final response = await _apiClient.get('/notifications/preferences');
    final data = response.data as Map<String, dynamic>;
    return NotificationPreferencesModel.fromJson(data);
  }

  @override
  Future<NotificationPreferencesModel> updatePreferences(Map<String, dynamic> body) async {
    final response = await _apiClient.patch('/notifications/preferences', data: body);
    final data = response.data as Map<String, dynamic>;
    return NotificationPreferencesModel.fromJson(data);
  }

  @override
  Future<void> registerDeviceToken(String deviceId, String token, String platform) async {
    await _apiClient.post('/notifications/device', data: {
      'deviceId': deviceId,
      'token': token,
      'platform': platform,
    });
  }

  @override
  Future<List<ActivityModel>> getActivityTimeline() async {
    final response = await _apiClient.get('/notifications/activity');
    final rawData = response.data;
    List<dynamic> list = [];
    if (rawData is List<dynamic>) {
      list = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['data'] is List<dynamic>) {
      list = rawData['data'] as List<dynamic>;
    }
    return list.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
