import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequestedEvent extends AuthEvent {}
class AuthLogoutRequestedEvent extends AuthEvent {}

// Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthenticatedState extends AuthState {
  final String userId;
  const AuthenticatedState({required this.userId});

  @override
  List<Object?> get props => [userId];
}
class UnauthenticatedState extends AuthState {}

// Auth BLoC Placeholder Foundation
class AuthBlocPlaceholder extends Bloc<AuthEvent, AuthState> {
  AuthBlocPlaceholder() : super(AuthInitialState()) {
    on<AuthCheckRequestedEvent>((event, emit) {
      emit(UnauthenticatedState());
    });

    on<AuthLogoutRequestedEvent>((event, emit) {
      emit(UnauthenticatedState());
    });
  }
}
