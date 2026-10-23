import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/security_entity.dart';
import '../../domain/usecases/enable_biometric_usecase.dart';
import '../../domain/usecases/logout_other_devices_usecase.dart';
import '../../domain/usecases/update_preferences_usecase.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final EnableBiometricUseCase enableBiometricUseCase;
  final LogoutOtherDevicesUseCase logoutOtherDevicesUseCase;
  final UpdatePreferencesUseCase updatePreferencesUseCase;

  SecurityBloc({
    required this.enableBiometricUseCase,
    required this.logoutOtherDevicesUseCase,
    required this.updatePreferencesUseCase,
  }) : super(SecurityLoaded(SecurityEntity.initial())) {
    on<ToggleBiometricEvent>(_onToggleBiometric);
    on<TogglePinLockEvent>(_onTogglePinLock);
    on<ChangeSessionTimeoutEvent>(_onChangeSessionTimeout);
    on<LogoutAllOtherDevicesEvent>(_onLogoutAllOtherDevices);
  }

  Future<void> _onToggleBiometric(ToggleBiometricEvent event, Emitter<SecurityState> emit) async {
    if (state is SecurityLoaded) {
      final current = (state as SecurityLoaded).security;
      final res = await enableBiometricUseCase(event.enable);
      res.fold(
        (failure) => emit(SecurityError(failure.message)),
        (enabled) {
          final updated = current.copyWith(isBiometricEnabled: enabled);
          emit(SecurityLoaded(updated, statusMessage: 'Biometric settings updated'));
        },
      );
    }
  }

  Future<void> _onTogglePinLock(TogglePinLockEvent event, Emitter<SecurityState> emit) async {
    if (state is SecurityLoaded) {
      final current = (state as SecurityLoaded).security;
      final updated = current.copyWith(isPinLockEnabled: event.enable);
      await updatePreferencesUseCase(UpdatePreferencesParams(security: updated));
      emit(SecurityLoaded(updated, statusMessage: 'PIN lock updated'));
    }
  }

  Future<void> _onChangeSessionTimeout(ChangeSessionTimeoutEvent event, Emitter<SecurityState> emit) async {
    if (state is SecurityLoaded) {
      final current = (state as SecurityLoaded).security;
      final updated = current.copyWith(sessionTimeoutMinutes: event.minutes);
      await updatePreferencesUseCase(UpdatePreferencesParams(security: updated));
      emit(SecurityLoaded(updated, statusMessage: 'Session timeout updated'));
    }
  }

  Future<void> _onLogoutAllOtherDevices(LogoutAllOtherDevicesEvent event, Emitter<SecurityState> emit) async {
    if (state is SecurityLoaded) {
      final current = (state as SecurityLoaded).security;
      emit(SecurityLoading());
      final res = await logoutOtherDevicesUseCase(const NoParams());
      res.fold(
        (failure) => emit(SecurityError(failure.message)),
        (_) {
          final updated = current.copyWith(activeSessionsCount: 1);
          emit(SecurityLoaded(updated, statusMessage: 'All other devices logged out successfully'));
        },
      );
    }
  }
}
