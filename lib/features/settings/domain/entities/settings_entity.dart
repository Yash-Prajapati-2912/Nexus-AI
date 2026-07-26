import 'package:equatable/equatable.dart';
import 'theme_entity.dart';
import 'language_entity.dart';
import 'accessibility_entity.dart';
import 'security_entity.dart';
import 'privacy_entity.dart';
import 'ai_preferences_entity.dart';
import 'notification_preference_entity.dart';
import 'backup_entity.dart';
import 'developer_settings_entity.dart';

class SettingsEntity extends Equatable {
  final String id;
  final String userId;
  final ThemeEntity theme;
  final LanguageEntity language;
  final AccessibilityEntity accessibility;
  final SecurityEntity security;
  final PrivacyEntity privacy;
  final AIPreferencesEntity aiPreferences;
  final NotificationPreferenceEntity notificationPreferences;
  final BackupEntity backup;
  final DeveloperSettingsEntity developerSettings;
  final DateTime updatedAt;

  const SettingsEntity({
    required this.id,
    required this.userId,
    required this.theme,
    required this.language,
    required this.accessibility,
    required this.security,
    required this.privacy,
    required this.aiPreferences,
    required this.notificationPreferences,
    required this.backup,
    required this.developerSettings,
    required this.updatedAt,
  });

  factory SettingsEntity.initial() {
    return SettingsEntity(
      id: 'default-settings',
      userId: '',
      theme: ThemeEntity.initial(),
      language: LanguageEntity.initial(),
      accessibility: AccessibilityEntity.initial(),
      security: SecurityEntity.initial(),
      privacy: PrivacyEntity.initial(),
      aiPreferences: AIPreferencesEntity.initial(),
      notificationPreferences: NotificationPreferenceEntity.initial(),
      backup: BackupEntity.initial(),
      developerSettings: DeveloperSettingsEntity.initial(),
      updatedAt: DateTime.now(),
    );
  }

  SettingsEntity copyWith({
    String? id,
    String? userId,
    ThemeEntity? theme,
    LanguageEntity? language,
    AccessibilityEntity? accessibility,
    SecurityEntity? security,
    PrivacyEntity? privacy,
    AIPreferencesEntity? aiPreferences,
    NotificationPreferenceEntity? notificationPreferences,
    BackupEntity? backup,
    DeveloperSettingsEntity? developerSettings,
    DateTime? updatedAt,
  }) {
    return SettingsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      accessibility: accessibility ?? this.accessibility,
      security: security ?? this.security,
      privacy: privacy ?? this.privacy,
      aiPreferences: aiPreferences ?? this.aiPreferences,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      backup: backup ?? this.backup,
      developerSettings: developerSettings ?? this.developerSettings,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        theme,
        language,
        accessibility,
        security,
        privacy,
        aiPreferences,
        notificationPreferences,
        backup,
        developerSettings,
        updatedAt,
      ];
}
