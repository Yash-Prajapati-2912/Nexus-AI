import 'package:equatable/equatable.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/connected_device_entity.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<SessionEntity> sessions;
  final List<ConnectedDeviceEntity> devices;
  final String? message;

  const SessionLoaded({
    required this.sessions,
    required this.devices,
    this.message,
  });

  @override
  List<Object?> get props => [sessions, devices, message];
}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}
