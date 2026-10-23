import 'package:equatable/equatable.dart';

/// Domain entity representing Security overview and status.
class SecuritySettings extends Equatable {
  final bool twoFactorEnabled;
  final int activeSessionsCount;
  final int trustedDevicesCount;
  final DateTime? lastPasswordChange;

  const SecuritySettings({
    required this.twoFactorEnabled,
    required this.activeSessionsCount,
    required this.trustedDevicesCount,
    this.lastPasswordChange,
  });

  @override
  List<Object?> get props => [
        twoFactorEnabled,
        activeSessionsCount,
        trustedDevicesCount,
        lastPasswordChange,
      ];
}
