import 'package:equatable/equatable.dart';

class ConnectedDeviceEntity extends Equatable {
  final String deviceId;
  final String name;
  final String platform;
  final bool isTrusted;
  final DateTime lastSeen;
  final String appVersion;

  const ConnectedDeviceEntity({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.isTrusted,
    required this.lastSeen,
    required this.appVersion,
  });

  ConnectedDeviceEntity copyWith({
    String? deviceId,
    String? name,
    String? platform,
    bool? isTrusted,
    DateTime? lastSeen,
    String? appVersion,
  }) {
    return ConnectedDeviceEntity(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      isTrusted: isTrusted ?? this.isTrusted,
      lastSeen: lastSeen ?? this.lastSeen,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [
        deviceId,
        name,
        platform,
        isTrusted,
        lastSeen,
        appVersion,
      ];
}
