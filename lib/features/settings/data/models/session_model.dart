import '../../domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.sessionId,
    required super.deviceName,
    required super.deviceType,
    required super.ipAddress,
    required super.location,
    required super.lastActive,
    required super.isCurrentSession,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['id'] as String? ?? json['sessionId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? 'Unknown Device',
      deviceType: json['deviceType'] as String? ?? 'Mobile',
      ipAddress: json['ipAddress'] as String? ?? '127.0.0.1',
      location: json['location'] as String? ?? 'Unknown Location',
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : DateTime.now(),
      isCurrentSession: json['isCurrentSession'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': sessionId,
      'sessionId': sessionId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'ipAddress': ipAddress,
      'location': location,
      'lastActive': lastActive.toIso8601String(),
      'isCurrentSession': isCurrentSession,
    };
  }

  factory SessionModel.fromEntity(SessionEntity entity) {
    return SessionModel(
      sessionId: entity.sessionId,
      deviceName: entity.deviceName,
      deviceType: entity.deviceType,
      ipAddress: entity.ipAddress,
      location: entity.location,
      lastActive: entity.lastActive,
      isCurrentSession: entity.isCurrentSession,
    );
  }
}
