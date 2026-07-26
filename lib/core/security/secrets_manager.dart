import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/app_logger.dart';

class SecretsManager {
  final FlutterSecureStorage secureStorage;

  SecretsManager(this.secureStorage);

  Future<void> storeSecret(String key, String value) async {
    await secureStorage.write(key: key, value: value);
    AppLogger.info('SecretsManager: Securely stored key [$key]');
  }

  Future<String?> getSecret(String key) async {
    return await secureStorage.read(key: key);
  }

  Future<void> deleteSecret(String key) async {
    await secureStorage.delete(key: key);
  }

  Future<void> clearAllSecrets() async {
    await secureStorage.deleteAll();
    AppLogger.info('SecretsManager: Cleared all encrypted storage secrets.');
  }
}
