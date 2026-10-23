import 'secure_token_storage.dart';
import 'preferences_manager.dart';

/// App User Session Lifecycle Manager.
class SessionManager {
  final SecureTokenStorage _secureStorage;
  final PreferencesManager _preferencesManager;

  SessionManager({
    required SecureTokenStorage secureStorage,
    required PreferencesManager preferencesManager,
  })  : _secureStorage = secureStorage,
        _preferencesManager = preferencesManager;

  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> clearSession() async {
    await _secureStorage.clearTokens();
    await _preferencesManager.remove('pref_user_profile');
  }
}
