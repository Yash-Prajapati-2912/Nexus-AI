import 'package:equatable/equatable.dart';

class SecurityEntity extends Equatable {
  final bool isBiometricEnabled;
  final bool isPinLockEnabled;
  final bool isAppLockEnabled;
  final int sessionTimeoutMinutes;
  final bool mfaEnabled;
  final int activeSessionsCount;

  const SecurityEntity({
    required this.isBiometricEnabled,
    required this.isPinLockEnabled,
    required this.isAppLockEnabled,
    required this.sessionTimeoutMinutes,
    required this.mfaEnabled,
    required this.activeSessionsCount,
  });

  factory SecurityEntity.initial() {
    return const SecurityEntity(
      isBiometricEnabled: false,
      isPinLockEnabled: false,
      isAppLockEnabled: false,
      sessionTimeoutMinutes: 30,
      mfaEnabled: false,
      activeSessionsCount: 1,
    );
  }

  SecurityEntity copyWith({
    bool? isBiometricEnabled,
    bool? isPinLockEnabled,
    bool? isAppLockEnabled,
    int? sessionTimeoutMinutes,
    bool? mfaEnabled,
    int? activeSessionsCount,
  }) {
    return SecurityEntity(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isPinLockEnabled: isPinLockEnabled ?? this.isPinLockEnabled,
      isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      activeSessionsCount: activeSessionsCount ?? this.activeSessionsCount,
    );
  }

  @override
  List<Object?> get props => [
        isBiometricEnabled,
        isPinLockEnabled,
        isAppLockEnabled,
        sessionTimeoutMinutes,
        mfaEnabled,
        activeSessionsCount,
      ];
}
