import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/constants/storage_keys.dart';

/// Hardware-Backed Secure Token Storage Manager.
class SecureTokenStorage {
  final FlutterSecureStorage _storage;

  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(StorageKeys.accessToken, accessToken);
    await write(StorageKeys.refreshToken, refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await read(StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await read(StorageKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }
}
