import 'package:equatable/equatable.dart';

abstract class AdminAuthEvent extends Equatable {
  const AdminAuthEvent();

  @override
  List<Object?> get props => [];
}

class AdminLoginRequested extends AdminAuthEvent {
  final String email;
  final String password;

  const AdminLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AdminLogoutRequested extends AdminAuthEvent {}
