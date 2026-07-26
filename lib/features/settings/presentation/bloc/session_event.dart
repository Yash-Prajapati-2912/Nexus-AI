import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSessionsEvent extends SessionEvent {}

class TerminateSessionEvent extends SessionEvent {
  final String sessionId;
  const TerminateSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class RemoveDeviceEvent extends SessionEvent {
  final String deviceId;
  const RemoveDeviceEvent(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}
