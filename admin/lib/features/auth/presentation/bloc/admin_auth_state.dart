import 'package:equatable/equatable.dart';

abstract class AdminAuthState extends Equatable {
  const AdminAuthState();

  @override
  List<Object?> get props => [];
}

class AdminAuthInitial extends AdminAuthState {}

class AdminAuthLoading extends AdminAuthState {}

class AdminAuthenticated extends AdminAuthState {
  final String email;
  final String role;

  const AdminAuthenticated(this.email, this.role);

  @override
  List<Object?> get props => [email, role];
}

class AdminUnauthenticated extends AdminAuthState {}

class AdminAuthFailure extends AdminAuthState {
  final String message;

  const AdminAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
