import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final String deviceName;
  final String deviceType;
  final String ipAddress;
  final String location;
  final DateTime lastActive;
  final bool isCurrentSession;

  const SessionEntity({
    required this.sessionId,
    required this.deviceName,
    required this.deviceType,
    required this.ipAddress,
    required this.location,
    required this.lastActive,
    required this.isCurrentSession,
  });

  @override
  List<Object?> get props => [
        sessionId,
        deviceName,
        deviceType,
        ipAddress,
        location,
        lastActive,
        isCurrentSession,
      ];
}
