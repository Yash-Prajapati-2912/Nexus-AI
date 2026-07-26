import 'package:equatable/equatable.dart';
import '../../domain/entities/privacy_entity.dart';

abstract class PrivacyState extends Equatable {
  const PrivacyState();

  @override
  List<Object?> get props => [];
}

class PrivacyInitial extends PrivacyState {}

class PrivacyLoading extends PrivacyState {}

class PrivacyLoaded extends PrivacyState {
  final PrivacyEntity privacy;
  final String? successMessage;

  const PrivacyLoaded(this.privacy, {this.successMessage});

  @override
  List<Object?> get props => [privacy, successMessage];
}

class PrivacyError extends PrivacyState {
  final String message;
  const PrivacyError(this.message);

  @override
  List<Object?> get props => [message];
}
