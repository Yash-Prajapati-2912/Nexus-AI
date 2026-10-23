import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants/storage_keys.dart';

/// SharedPreferences Preferences Manager wrapper.
class PreferencesManager {
  final SharedPreferences _prefs;

  PreferencesManager(this._prefs);

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  bool get isOnboarded => getBool(StorageKeys.onboarded, defaultValue: false);

  Future<bool> setOnboarded(bool value) async {
    return await setBool(StorageKeys.onboarded, value);
  }

  String? get themeMode => getString(StorageKeys.themeMode);

  Future<bool> setThemeMode(String mode) async {
    return await setString(StorageKeys.themeMode, mode);
  }

  String get languageCode => getString(StorageKeys.languageCode) ?? 'en';

  Future<bool> setLanguageCode(String code) async {
    return await setString(StorageKeys.languageCode, code);
  }
}
