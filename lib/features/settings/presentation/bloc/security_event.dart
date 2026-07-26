import 'package:equatable/equatable.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

class ToggleBiometricEvent extends SecurityEvent {
  final bool enable;
  const ToggleBiometricEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class TogglePinLockEvent extends SecurityEvent {
  final bool enable;
  const TogglePinLockEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class ChangeSessionTimeoutEvent extends SecurityEvent {
  final int minutes;
  const ChangeSessionTimeoutEvent(this.minutes);

  @override
  List<Object?> get props => [minutes];
}

class LogoutAllOtherDevicesEvent extends SecurityEvent {}
