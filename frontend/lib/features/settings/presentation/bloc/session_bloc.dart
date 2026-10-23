import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/usecases/terminate_session_usecase.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final ISettingsRepository repository;
  final TerminateSessionUseCase terminateSessionUseCase;

  SessionBloc({
    required this.repository,
    required this.terminateSessionUseCase,
  }) : super(SessionInitial()) {
    on<LoadSessionsEvent>(_onLoadSessions);
    on<TerminateSessionEvent>(_onTerminateSession);
    on<RemoveDeviceEvent>(_onRemoveDevice);
  }

  Future<void> _onLoadSessions(LoadSessionsEvent event, Emitter<SessionState> emit) async {
    emit(SessionLoading());
    final sessionsRes = await repository.getActiveSessions();
    final devicesRes = await repository.getConnectedDevices();

    sessionsRes.fold(
      (failure) => emit(SessionError(failure.message)),
      (sessions) {
        devicesRes.fold(
          (failure) => emit(SessionError(failure.message)),
          (devices) => emit(SessionLoaded(sessions: sessions, devices: devices)),
        );
      },
    );
  }

  Future<void> _onTerminateSession(TerminateSessionEvent event, Emitter<SessionState> emit) async {
    if (state is SessionLoaded) {
      final current = state as SessionLoaded;
      final res = await terminateSessionUseCase(event.sessionId);
      res.fold(
        (failure) => emit(SessionError(failure.message)),
        (_) {
          final updatedSessions = current.sessions.where((s) => s.sessionId != event.sessionId).toList();
          emit(SessionLoaded(
            sessions: updatedSessions,
            devices: current.devices,
            message: 'Session terminated',
          ));
        },
      );
    }
  }

  Future<void> _onRemoveDevice(RemoveDeviceEvent event, Emitter<SessionState> emit) async {
    if (state is SessionLoaded) {
      final current = state as SessionLoaded;
      final res = await repository.removeConnectedDevice(event.deviceId);
      res.fold(
        (failure) => emit(SessionError(failure.message)),
        (_) {
          final updatedDevices = current.devices.where((d) => d.deviceId != event.deviceId).toList();
          emit(SessionLoaded(
            sessions: current.sessions,
            devices: updatedDevices,
            message: 'Device removed',
          ));
        },
      );
    }
  }
}
