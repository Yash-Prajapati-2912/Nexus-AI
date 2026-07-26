import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/change_password_usecase.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();
  @override
  List<Object?> get props => [];
}

class LoadSecuritySettingsEvent extends SecurityEvent {
  const LoadSecuritySettingsEvent();
}

class ChangePasswordSubmitEvent extends SecurityEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordSubmitEvent({required this.currentPassword, required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

abstract class SecurityState extends Equatable {
  const SecurityState();
  @override
  List<Object?> get props => [];
}

class SecurityInitialState extends SecurityState {
  const SecurityInitialState();
}

class SecurityLoadingState extends SecurityState {
  const SecurityLoadingState();
}

class SecurityLoadedState extends SecurityState {
  final SecuritySettings settings;
  final bool isPasswordChanged;

  const SecurityLoadedState({required this.settings, this.isPasswordChanged = false});

  @override
  List<Object?> get props => [settings, isPasswordChanged];
}

class SecurityFailureState extends SecurityState {
  final String message;
  const SecurityFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final IProfileRepository repository;

  SecurityBloc({
    required this.changePasswordUseCase,
    required this.repository,
  }) : super(const SecurityInitialState()) {
    on<LoadSecuritySettingsEvent>(_onLoadSecurity);
    on<ChangePasswordSubmitEvent>(_onChangePassword);
  }

  Future<void> _onLoadSecurity(LoadSecuritySettingsEvent event, Emitter<SecurityState> emit) async {
    emit(const SecurityLoadingState());
    final res = await repository.getSecuritySettings();
    res.fold(
      (Failure f) => emit(SecurityFailureState(f.message)),
      (sec) => emit(SecurityLoadedState(settings: sec)),
    );
  }

  Future<void> _onChangePassword(ChangePasswordSubmitEvent event, Emitter<SecurityState> emit) async {
    final res = await changePasswordUseCase(ChangePasswordParams(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    ));

    if (state is SecurityLoadedState) {
      final current = state as SecurityLoadedState;
      res.fold(
        (Failure f) => emit(SecurityFailureState(f.message)),
        (_) => emit(SecurityLoadedState(settings: current.settings, isPasswordChanged: true)),
      );
    }
  }
}
