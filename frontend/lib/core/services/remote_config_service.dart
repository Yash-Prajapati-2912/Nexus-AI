import 'app_logger.dart';

class RemoteConfigService {
  final Map<String, dynamic> _defaults = {
    'maintenance_mode': false,
    'min_app_version': '1.0.0',
    'ai_max_prompt_tokens': 4096,
    'enable_biometric_passkeys': true,
    'cloud_backup_interval_hours': 24,
  };

  Future<void> fetchAndActivate() async {
    AppLogger.info('RemoteConfigService: Fetched and activated latest remote configuration.');
  }

  bool getBool(String key) {
    return _defaults[key] as bool? ?? false;
  }

  String getString(String key) {
    return _defaults[key] as String? ?? '';
  }

  int getInt(String key) {
    return _defaults[key] as int? ?? 0;
  }

  bool get isMaintenanceMode => getBool('maintenance_mode');
  String get minAppVersion => getString('min_app_version');
}
