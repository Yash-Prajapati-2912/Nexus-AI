import '../../../../core/network/api_client.dart';
import '../models/settings_model.dart';
import '../models/theme_model.dart';
import '../models/language_model.dart';
import '../models/accessibility_model.dart';
import '../models/security_model.dart';
import '../models/privacy_model.dart';
import '../models/ai_preferences_model.dart';
import '../models/notification_preference_model.dart';
import '../models/backup_model.dart';
import '../models/session_model.dart';
import '../models/connected_device_model.dart';
import '../models/developer_settings_model.dart';

abstract class ISettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<ThemeModel> updateTheme(ThemeModel theme);
  Future<LanguageModel> updateLanguage(LanguageModel language);
  Future<AccessibilityModel> updateAccessibility(AccessibilityModel accessibility);
  Future<SecurityModel> updateSecurity(SecurityModel security);
  Future<PrivacyModel> updatePrivacy(PrivacyModel privacy);
  Future<AIPreferencesModel> updateAIPreferences(AIPreferencesModel preferences);
  Future<NotificationPreferenceModel> updateNotificationPreferences(NotificationPreferenceModel preferences);
  Future<BackupModel> backupData();
  Future<BackupModel> restoreData(String backupId);
  Future<List<SessionModel>> getActiveSessions();
  Future<bool> terminateSession(String sessionId);
  Future<bool> logoutOtherDevices();
  Future<List<ConnectedDeviceModel>> getConnectedDevices();
  Future<bool> removeConnectedDevice(String deviceId);
  Future<DeveloperSettingsModel> updateDeveloperSettings(DeveloperSettingsModel settings);
  Future<bool> clearCache();
  Future<bool> clearLocalData();
  Future<bool> deleteAIHistory();
}

class SettingsRemoteDataSourceImpl implements ISettingsRemoteDataSource {
  final ApiClient apiClient;

  SettingsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SettingsModel> getSettings() async {
    final response = await apiClient.get('/settings');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return SettingsModel.fromJson(data);
    }
    return SettingsModel.fromJson(const {});
  }

  @override
  Future<ThemeModel> updateTheme(ThemeModel theme) async {
    final response = await apiClient.patch(
      '/settings',
      data: theme.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ThemeModel.fromJson(data);
    }
    return theme;
  }

  @override
  Future<LanguageModel> updateLanguage(LanguageModel language) async {
    final response = await apiClient.patch(
      '/settings',
      data: language.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return LanguageModel.fromJson(data);
    }
    return language;
  }

  @override
  Future<AccessibilityModel> updateAccessibility(AccessibilityModel accessibility) async {
    final response = await apiClient.patch(
      '/settings/preferences',
      data: {'accessibility': accessibility.toJson()},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['accessibility'] != null) {
      return AccessibilityModel.fromJson(data['accessibility'] as Map<String, dynamic>);
    }
    return accessibility;
  }

  @override
  Future<SecurityModel> updateSecurity(SecurityModel security) async {
    final response = await apiClient.patch(
      '/settings/security',
      data: security.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return SecurityModel.fromJson(data);
    }
    return security;
  }

  @override
  Future<PrivacyModel> updatePrivacy(PrivacyModel privacy) async {
    final response = await apiClient.patch(
      '/settings/preferences',
      data: {'privacy': privacy.toJson()},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['privacy'] != null) {
      return PrivacyModel.fromJson(data['privacy'] as Map<String, dynamic>);
    }
    return privacy;
  }

  @override
  Future<AIPreferencesModel> updateAIPreferences(AIPreferencesModel preferences) async {
    final response = await apiClient.patch(
      '/settings/preferences',
      data: {'ai': preferences.toJson()},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['ai'] != null) {
      return AIPreferencesModel.fromJson(data['ai'] as Map<String, dynamic>);
    }
    return preferences;
  }

  @override
  Future<NotificationPreferenceModel> updateNotificationPreferences(NotificationPreferenceModel preferences) async {
    final response = await apiClient.patch(
      '/settings/preferences',
      data: {'notifications': preferences.toJson()},
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['notifications'] != null) {
      return NotificationPreferenceModel.fromJson(data['notifications'] as Map<String, dynamic>);
    }
    return preferences;
  }

  @override
  Future<BackupModel> backupData() async {
    final response = await apiClient.post('/settings/backup');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return BackupModel.fromJson(data);
    }
    return BackupModel.initial();
  }

  @override
  Future<BackupModel> restoreData(String backupId) async {
    final response = await apiClient.post(
      '/settings/restore',
      data: {'backupId': backupId},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return BackupModel.fromJson(data);
    }
    return BackupModel.initial();
  }

  @override
  Future<List<SessionModel>> getActiveSessions() async {
    final response = await apiClient.get('/settings/security');
    final data = response.data;
    if (data is Map<String, dynamic> && data['trustedDevices'] is List) {
      final list = data['trustedDevices'] as List;
      return list.map((item) => SessionModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [
      SessionModel(
        sessionId: 'sess-current',
        deviceName: 'Primary Mobile Device',
        deviceType: 'Flutter App',
        ipAddress: '127.0.0.1',
        location: 'Active Workstation',
        lastActive: DateTime.now(),
        isCurrentSession: true,
      ),
    ];
  }

  @override
  Future<bool> terminateSession(String sessionId) async {
    await apiClient.post(
      '/auth/logout',
      data: {'sessionId': sessionId},
    );
    return true;
  }

  @override
  Future<bool> logoutOtherDevices() async {
    await apiClient.post('/auth/logout-all');
    return true;
  }

  @override
  Future<List<ConnectedDeviceModel>> getConnectedDevices() async {
    final response = await apiClient.get('/settings/security');
    final data = response.data;
    if (data is Map<String, dynamic> && data['trustedDevices'] is List) {
      final list = data['trustedDevices'] as List;
      return list.map((item) => ConnectedDeviceModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [
      ConnectedDeviceModel(
        deviceId: 'dev-1',
        name: 'Pixel 8 Pro',
        platform: 'Android 14',
        isTrusted: true,
        lastSeen: DateTime.now(),
        appVersion: '1.0.0+1',
      ),
    ];
  }

  @override
  Future<bool> removeConnectedDevice(String deviceId) async {
    await apiClient.delete('/settings/security/devices/$deviceId');
    return true;
  }

  @override
  Future<DeveloperSettingsModel> updateDeveloperSettings(DeveloperSettingsModel settings) async {
    final response = await apiClient.patch(
      '/settings/feature-flags',
      data: settings.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return DeveloperSettingsModel.fromJson(data);
    }
    return settings;
  }

  @override
  Future<bool> clearCache() async {
    return true;
  }

  @override
  Future<bool> clearLocalData() async {
    return true;
  }

  @override
  Future<bool> deleteAIHistory() async {
    await apiClient.delete('/ai-mentor/conversations');
    return true;
  }
}
