import '../../domain/entities/security_settings.dart';

class SecuritySettingsModel extends SecuritySettings {
  const SecuritySettingsModel({
    required super.twoFactorEnabled,
    required super.activeSessionsCount,
    required super.trustedDevicesCount,
    super.lastPasswordChange,
  });

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return SecuritySettingsModel(
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      activeSessionsCount: json['activeSessionsCount'] as int? ?? 2,
      trustedDevicesCount: json['trustedDevicesCount'] as int? ?? 1,
      lastPasswordChange: json['lastPasswordChange'] != null ? DateTime.parse(json['lastPasswordChange'] as String) : DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'twoFactorEnabled': twoFactorEnabled,
      'activeSessionsCount': activeSessionsCount,
      'trustedDevicesCount': trustedDevicesCount,
      'lastPasswordChange': lastPasswordChange?.toIso8601String(),
    };
  }
}
