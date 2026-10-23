import 'package:equatable/equatable.dart';
import '../../domain/entities/security_entity.dart';

abstract class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

class SecurityInitial extends SecurityState {}

class SecurityLoading extends SecurityState {}

class SecurityLoaded extends SecurityState {
  final SecurityEntity security;
  final String? statusMessage;

  const SecurityLoaded(this.security, {this.statusMessage});

  @override
  List<Object?> get props => [security, statusMessage];
}

class SecurityError extends SecurityState {
  final String message;
  const SecurityError(this.message);

  @override
  List<Object?> get props => [message];
}
