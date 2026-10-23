import '../../domain/entities/settings_entity.dart';
import 'theme_model.dart';
import 'language_model.dart';
import 'accessibility_model.dart';
import 'security_model.dart';
import 'privacy_model.dart';
import 'ai_preferences_model.dart';
import 'notification_preference_model.dart';
import 'backup_model.dart';
import 'developer_settings_model.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.id,
    required super.userId,
    required super.theme,
    required super.language,
    required super.accessibility,
    required super.security,
    required super.privacy,
    required super.aiPreferences,
    required super.notificationPreferences,
    required super.backup,
    required super.developerSettings,
    required super.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> castMap(dynamic val, [Map<String, dynamic>? fallback]) {
      if (val is Map<String, dynamic>) return val;
      if (val is Map) return Map<String, dynamic>.from(val);
      return fallback ?? <String, dynamic>{};
    }

    return SettingsModel(
      id: json['id'] as String? ?? 'settings-1',
      userId: json['userId'] as String? ?? '',
      theme: ThemeModel.fromJson(castMap(json['theme'], json)),
      language: LanguageModel.fromJson(castMap(json['language'], json)),
      accessibility: AccessibilityModel.fromJson(castMap(json['accessibility'])),
      security: SecurityModel.fromJson(castMap(json['security'])),
      privacy: PrivacyModel.fromJson(castMap(json['privacy'] ?? json['privacySettings'])),
      aiPreferences: AIPreferencesModel.fromJson(castMap(json['aiPreferences'] ?? json['ai'])),
      notificationPreferences: NotificationPreferenceModel.fromJson(castMap(json['notificationPreferences'])),
      backup: BackupModel.fromJson(castMap(json['backup'])),
      developerSettings: DeveloperSettingsModel.fromJson(castMap(json['developerSettings'])),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'theme': ThemeModel.fromEntity(theme).toJson(),
      'language': LanguageModel.fromEntity(language).toJson(),
      'accessibility': AccessibilityModel.fromEntity(accessibility).toJson(),
      'security': SecurityModel.fromEntity(security).toJson(),
      'privacy': PrivacyModel.fromEntity(privacy).toJson(),
      'aiPreferences': AIPreferencesModel.fromEntity(aiPreferences).toJson(),
      'notificationPreferences': NotificationPreferenceModel.fromEntity(notificationPreferences).toJson(),
      'backup': BackupModel.fromEntity(backup).toJson(),
      'developerSettings': DeveloperSettingsModel.fromEntity(developerSettings).toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      id: entity.id,
      userId: entity.userId,
      theme: entity.theme,
      language: entity.language,
      accessibility: entity.accessibility,
      security: entity.security,
      privacy: entity.privacy,
      aiPreferences: entity.aiPreferences,
      notificationPreferences: entity.notificationPreferences,
      backup: entity.backup,
      developerSettings: entity.developerSettings,
      updatedAt: entity.updatedAt,
    );
  }
}
