import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AppStartedEvent extends AuthenticationEvent {}

class LoginRequestedEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequestedEvent({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class RegisterRequestedEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String fullName;

  const RegisterRequestedEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class LogoutRequestedEvent extends AuthenticationEvent {}

class LogoutAllRequestedEvent extends AuthenticationEvent {}

class ForgotPasswordRequestedEvent extends AuthenticationEvent {
  final String email;
  const ForgotPasswordRequestedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequestedEvent extends AuthenticationEvent {
  final String token;
  final String newPassword;

  const ResetPasswordRequestedEvent({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

class VerifyEmailRequestedEvent extends AuthenticationEvent {
  final String token;
  const VerifyEmailRequestedEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class ResendVerificationRequestedEvent extends AuthenticationEvent {
  final String email;
  const ResendVerificationRequestedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class RefreshTokenRequestedEvent extends AuthenticationEvent {}

class LoadCurrentUserRequestedEvent extends AuthenticationEvent {}
