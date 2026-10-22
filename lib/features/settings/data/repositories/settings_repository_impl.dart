import 'package:flutter/painting.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/entities/accessibility_entity.dart';
import '../../domain/entities/security_entity.dart';
import '../../domain/entities/privacy_entity.dart';
import '../../domain/entities/ai_preferences_entity.dart';
import '../../domain/entities/notification_preference_entity.dart';
import '../../domain/entities/backup_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/connected_device_entity.dart';
import '../../domain/entities/developer_settings_entity.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';
import '../models/theme_model.dart';
import '../models/language_model.dart';
import '../models/accessibility_model.dart';
import '../models/security_model.dart';
import '../models/privacy_model.dart';
import '../models/ai_preferences_model.dart';
import '../models/notification_preference_model.dart';
import '../models/developer_settings_model.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsRemoteDataSource remoteDataSource;
  final ISettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final cached = await localDataSource.getCachedSettings();
      try {
        final remote = await remoteDataSource.getSettings();
        await localDataSource.cacheSettings(remote);
        return Right(remote);
      } catch (_) {
        if (cached != null) return Right(cached);
        return Right(SettingsEntity.initial());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ThemeEntity>> updateTheme(ThemeEntity theme) async {
    try {
      final model = ThemeModel.fromEntity(theme);
      await localDataSource.saveTheme(model);
      try {
        final updated = await remoteDataSource.updateTheme(model);
        return Right(updated);
      } catch (_) {
        return Right(theme);
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LanguageEntity>> updateLanguage(LanguageEntity language) async {
    try {
      final model = LanguageModel.fromEntity(language);
      await localDataSource.saveLanguage(model);
      try {
        final updated = await remoteDataSource.updateLanguage(model);
        return Right(updated);
      } catch (_) {
        return Right(language);
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccessibilityEntity>> updateAccessibility(AccessibilityEntity accessibility) async {
    try {
      final model = AccessibilityModel.fromEntity(accessibility);
      await localDataSource.saveAccessibility(model);
      try {
        final updated = await remoteDataSource.updateAccessibility(model);
        return Right(updated);
      } catch (_) {
        return Right(accessibility);
      }
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SecurityEntity>> updateSecurity(SecurityEntity security) async {
    try {
      final model = SecurityModel.fromEntity(security);
      final updated = await remoteDataSource.updateSecurity(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PrivacyEntity>> updatePrivacy(PrivacyEntity privacy) async {
    try {
      final model = PrivacyModel.fromEntity(privacy);
      final updated = await remoteDataSource.updatePrivacy(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AIPreferencesEntity>> updateAIPreferences(AIPreferencesEntity preferences) async {
    try {
      final model = AIPreferencesModel.fromEntity(preferences);
      final updated = await remoteDataSource.updateAIPreferences(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferenceEntity>> updateNotificationPreferences(
      NotificationPreferenceEntity preferences) async {
    try {
      final model = NotificationPreferenceModel.fromEntity(preferences);
      final updated = await remoteDataSource.updateNotificationPreferences(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> enableBiometric(bool enable) async {
    try {
      await localDataSource.setBiometricEnabled(enable);
      return Right(enable);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BackupEntity>> backupData() async {
    try {
      final backup = await remoteDataSource.backupData();
      return Right(backup);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BackupEntity>> restoreData(String backupId) async {
    try {
      final backup = await remoteDataSource.restoreData(backupId);
      return Right(backup);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SessionEntity>>> getActiveSessions() async {
    try {
      final sessions = await remoteDataSource.getActiveSessions();
      return Right(sessions);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> terminateSession(String sessionId) async {
    try {
      final res = await remoteDataSource.terminateSession(sessionId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutOtherDevices() async {
    try {
      final res = await remoteDataSource.logoutOtherDevices();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConnectedDeviceEntity>>> getConnectedDevices() async {
    try {
      final devices = await remoteDataSource.getConnectedDevices();
      return Right(devices);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeConnectedDevice(String deviceId) async {
    try {
      final res = await remoteDataSource.removeConnectedDevice(deviceId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeveloperSettingsEntity>> updateDeveloperSettings(DeveloperSettingsEntity settings) async {
    try {
      final model = DeveloperSettingsModel.fromEntity(settings);
      await localDataSource.saveDeveloperSettings(model);
      final updated = await remoteDataSource.updateDeveloperSettings(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearCache() async {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      await remoteDataSource.clearCache();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearLocalData() async {
    try {
      await localDataSource.clearAllSettings();
      await remoteDataSource.clearLocalData();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAIHistory() async {
    try {
      final res = await remoteDataSource.deleteAIHistory();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
