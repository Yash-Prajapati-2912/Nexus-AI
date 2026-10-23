import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/storage/preferences_manager.dart';
import '../models/settings_model.dart';
import '../models/theme_model.dart';
import '../models/language_model.dart';
import '../models/accessibility_model.dart';
import '../models/developer_settings_model.dart';

abstract class ISettingsLocalDataSource {
  Future<SettingsModel?> getCachedSettings();
  Future<void> cacheSettings(SettingsModel settings);
  Future<void> saveTheme(ThemeModel theme);
  Future<ThemeModel?> getTheme();
  Future<void> saveLanguage(LanguageModel language);
  Future<LanguageModel?> getLanguage();
  Future<void> saveAccessibility(AccessibilityModel accessibility);
  Future<AccessibilityModel?> getAccessibility();
  Future<void> saveDeveloperSettings(DeveloperSettingsModel developerSettings);
  Future<DeveloperSettingsModel?> getDeveloperSettings();
  Future<bool> isBiometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
  Future<void> clearAllSettings();
}

class SettingsLocalDataSourceImpl implements ISettingsLocalDataSource {
  final PreferencesManager preferencesManager;
  final FlutterSecureStorage secureStorage;

  static const String _settingsKey = 'cached_user_settings';
  static const String _themeKey = 'cached_theme_settings';
  static const String _languageKey = 'cached_language_settings';
  static const String _accessibilityKey = 'cached_accessibility_settings';
  static const String _developerKey = 'cached_developer_settings';
  static const String _biometricKey = 'biometric_enabled_secure';

  SettingsLocalDataSourceImpl({
    required this.preferencesManager,
    required this.secureStorage,
  });

  @override
  Future<SettingsModel?> getCachedSettings() async {
    final raw = preferencesManager.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return SettingsModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheSettings(SettingsModel settings) async {
    final raw = jsonEncode(settings.toJson());
    await preferencesManager.setString(_settingsKey, raw);
  }

  @override
  Future<void> saveTheme(ThemeModel theme) async {
    final raw = jsonEncode(theme.toJson());
    await preferencesManager.setString(_themeKey, raw);
    await preferencesManager.setThemeMode(theme.themeMode.name.toUpperCase());
  }

  @override
  Future<ThemeModel?> getTheme() async {
    final raw = preferencesManager.getString(_themeKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ThemeModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLanguage(LanguageModel language) async {
    final raw = jsonEncode(language.toJson());
    await preferencesManager.setString(_languageKey, raw);
    await preferencesManager.setLanguageCode(language.languageCode);
  }

  @override
  Future<LanguageModel?> getLanguage() async {
    final raw = preferencesManager.getString(_languageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return LanguageModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveAccessibility(AccessibilityModel accessibility) async {
    final raw = jsonEncode(accessibility.toJson());
    await preferencesManager.setString(_accessibilityKey, raw);
  }

  @override
  Future<AccessibilityModel?> getAccessibility() async {
    final raw = preferencesManager.getString(_accessibilityKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AccessibilityModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveDeveloperSettings(DeveloperSettingsModel developerSettings) async {
    final raw = jsonEncode(developerSettings.toJson());
    await preferencesManager.setString(_developerKey, raw);
  }

  @override
  Future<DeveloperSettingsModel?> getDeveloperSettings() async {
    final raw = preferencesManager.getString(_developerKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return DeveloperSettingsModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final val = await secureStorage.read(key: _biometricKey);
    return val == 'true';
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await secureStorage.write(key: _biometricKey, value: enabled.toString());
  }

  @override
  Future<void> clearAllSettings() async {
    await preferencesManager.remove(_settingsKey);
    await preferencesManager.remove(_themeKey);
    await preferencesManager.remove(_languageKey);
    await preferencesManager.remove(_accessibilityKey);
    await preferencesManager.remove(_developerKey);
    await secureStorage.delete(key: _biometricKey);
  }
}
