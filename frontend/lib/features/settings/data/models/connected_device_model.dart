import '../../domain/entities/connected_device_entity.dart';

class ConnectedDeviceModel extends ConnectedDeviceEntity {
  const ConnectedDeviceModel({
    required super.deviceId,
    required super.name,
    required super.platform,
    required super.isTrusted,
    required super.lastSeen,
    required super.appVersion,
  });

  factory ConnectedDeviceModel.fromJson(Map<String, dynamic> json) {
    return ConnectedDeviceModel(
      deviceId: json['deviceId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Device',
      platform: json['platform'] as String? ?? 'Unknown',
      isTrusted: json['isTrusted'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : DateTime.now(),
      appVersion: json['appVersion'] as String? ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'platform': platform,
      'isTrusted': isTrusted,
      'lastSeen': lastSeen.toIso8601String(),
      'appVersion': appVersion,
    };
  }

  factory ConnectedDeviceModel.fromEntity(ConnectedDeviceEntity entity) {
    return ConnectedDeviceModel(
      deviceId: entity.deviceId,
      name: entity.name,
      platform: entity.platform,
      isTrusted: entity.isTrusted,
      lastSeen: entity.lastSeen,
      appVersion: entity.appVersion,
    );
  }
}
