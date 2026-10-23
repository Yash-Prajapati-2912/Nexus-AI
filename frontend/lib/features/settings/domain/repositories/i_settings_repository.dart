import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/settings_entity.dart';
import '../entities/theme_entity.dart';
import '../entities/language_entity.dart';
import '../entities/accessibility_entity.dart';
import '../entities/security_entity.dart';
import '../entities/privacy_entity.dart';
import '../entities/ai_preferences_entity.dart';
import '../entities/notification_preference_entity.dart';
import '../entities/backup_entity.dart';
import '../entities/session_entity.dart';
import '../entities/connected_device_entity.dart';
import '../entities/developer_settings_entity.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure, ThemeEntity>> updateTheme(ThemeEntity theme);
  Future<Either<Failure, LanguageEntity>> updateLanguage(LanguageEntity language);
  Future<Either<Failure, AccessibilityEntity>> updateAccessibility(AccessibilityEntity accessibility);
  Future<Either<Failure, SecurityEntity>> updateSecurity(SecurityEntity security);
  Future<Either<Failure, PrivacyEntity>> updatePrivacy(PrivacyEntity privacy);
  Future<Either<Failure, AIPreferencesEntity>> updateAIPreferences(AIPreferencesEntity preferences);
  Future<Either<Failure, NotificationPreferenceEntity>> updateNotificationPreferences(NotificationPreferenceEntity preferences);
  Future<Either<Failure, bool>> enableBiometric(bool enable);
  Future<Either<Failure, BackupEntity>> backupData();
  Future<Either<Failure, BackupEntity>> restoreData(String backupId);
  Future<Either<Failure, List<SessionEntity>>> getActiveSessions();
  Future<Either<Failure, bool>> terminateSession(String sessionId);
  Future<Either<Failure, bool>> logoutOtherDevices();
  Future<Either<Failure, List<ConnectedDeviceEntity>>> getConnectedDevices();
  Future<Either<Failure, bool>> removeConnectedDevice(String deviceId);
  Future<Either<Failure, DeveloperSettingsEntity>> updateDeveloperSettings(DeveloperSettingsEntity settings);
  Future<Either<Failure, bool>> clearCache();
  Future<Either<Failure, bool>> clearLocalData();
  Future<Either<Failure, bool>> deleteAIHistory();
}
