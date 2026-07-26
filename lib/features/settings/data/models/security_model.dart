import '../../domain/entities/security_entity.dart';

class SecurityModel extends SecurityEntity {
  const SecurityModel({
    required super.isBiometricEnabled,
    required super.isPinLockEnabled,
    required super.isAppLockEnabled,
    required super.sessionTimeoutMinutes,
    required super.mfaEnabled,
    required super.activeSessionsCount,
  });

  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      isPinLockEnabled: json['isPinLockEnabled'] as bool? ?? false,
      isAppLockEnabled: json['isAppLockEnabled'] as bool? ?? false,
      sessionTimeoutMinutes: (json['sessionTimeoutMinutes'] as num?)?.toInt() ?? 30,
      mfaEnabled: json['mfaEnabled'] as bool? ?? false,
      activeSessionsCount: (json['activeSessionsCount'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isBiometricEnabled': isBiometricEnabled,
      'isPinLockEnabled': isPinLockEnabled,
      'isAppLockEnabled': isAppLockEnabled,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'mfaEnabled': mfaEnabled,
      'activeSessionsCount': activeSessionsCount,
    };
  }

  factory SecurityModel.fromEntity(SecurityEntity entity) {
    return SecurityModel(
      isBiometricEnabled: entity.isBiometricEnabled,
      isPinLockEnabled: entity.isPinLockEnabled,
      isAppLockEnabled: entity.isAppLockEnabled,
      sessionTimeoutMinutes: entity.sessionTimeoutMinutes,
      mfaEnabled: entity.mfaEnabled,
      activeSessionsCount: entity.activeSessionsCount,
    );
  }
}
