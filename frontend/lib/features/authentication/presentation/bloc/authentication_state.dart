import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthenticationState {}

class AuthLoadingState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {
  final UserEntity user;
  const AuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthenticationState {}

class EmailVerificationPendingState extends AuthenticationState {
  final String email;
  const EmailVerificationPendingState({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordResetSentState extends AuthenticationState {
  final String email;
  const PasswordResetSentState({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordResetSuccessState extends AuthenticationState {}

class EmailVerificationSuccessState extends AuthenticationState {}

class SessionExpiredState extends AuthenticationState {}

class AuthFailureState extends AuthenticationState {
  final String message;
  const AuthFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
