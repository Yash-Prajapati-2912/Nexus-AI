import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_preferences_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdatePreferencesUseCase updatePreferencesUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.updatePreferencesUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateAIPreferencesEvent>(_onUpdateAIPreferences);
    on<UpdateNotificationPreferencesEvent>(_onUpdateNotificationPreferences);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase(const NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateAIPreferences(UpdateAIPreferencesEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final result = await updatePreferencesUseCase(UpdatePreferencesParams(aiPreferences: event.preferences));
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) {
          final updated = currentSettings.copyWith(aiPreferences: event.preferences);
          emit(SettingsLoaded(updated));
        },
      );
    }
  }

  Future<void> _onUpdateNotificationPreferences(
      UpdateNotificationPreferencesEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final result =
          await updatePreferencesUseCase(UpdatePreferencesParams(notificationPreferences: event.preferences));
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) {
          final updated = currentSettings.copyWith(notificationPreferences: event.preferences);
          emit(SettingsLoaded(updated));
        },
      );
    }
  }
}
