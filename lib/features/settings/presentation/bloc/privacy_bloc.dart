import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/privacy_entity.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/usecases/update_preferences_usecase.dart';
import 'privacy_event.dart';
import 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final ISettingsRepository repository;
  final UpdatePreferencesUseCase updatePreferencesUseCase;

  PrivacyBloc({
    required this.repository,
    required this.updatePreferencesUseCase,
  }) : super(PrivacyLoaded(PrivacyEntity.initial())) {
    on<ToggleAnalyticsConsentEvent>(_onToggleAnalytics);
    on<ToggleCrashReportingEvent>(_onToggleCrashReporting);
    on<ToggleAIDataUsageEvent>(_onToggleAIDataUsage);
    on<ClearAppCacheEvent>(_onClearAppCache);
    on<ClearLocalDataEvent>(_onClearLocalData);
    on<DeleteAIHistoryEvent>(_onDeleteAIHistory);
  }

  Future<void> _onToggleAnalytics(ToggleAnalyticsConsentEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      final updated = current.copyWith(analyticsConsent: event.enable);
      await updatePreferencesUseCase(UpdatePreferencesParams(privacy: updated));
      emit(PrivacyLoaded(updated, successMessage: 'Analytics consent updated'));
    }
  }

  Future<void> _onToggleCrashReporting(ToggleCrashReportingEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      final updated = current.copyWith(crashReportingConsent: event.enable);
      await updatePreferencesUseCase(UpdatePreferencesParams(privacy: updated));
      emit(PrivacyLoaded(updated, successMessage: 'Crash reporting consent updated'));
    }
  }

  Future<void> _onToggleAIDataUsage(ToggleAIDataUsageEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      final updated = current.copyWith(aiDataUsageConsent: event.enable);
      await updatePreferencesUseCase(UpdatePreferencesParams(privacy: updated));
      emit(PrivacyLoaded(updated, successMessage: 'AI data usage consent updated'));
    }
  }

  Future<void> _onClearAppCache(ClearAppCacheEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      emit(PrivacyLoading());
      final res = await repository.clearCache();
      res.fold(
        (failure) => emit(PrivacyError(failure.message)),
        (_) => emit(PrivacyLoaded(current, successMessage: 'Application cache cleared successfully')),
      );
    }
  }

  Future<void> _onClearLocalData(ClearLocalDataEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      emit(PrivacyLoading());
      final res = await repository.clearLocalData();
      res.fold(
        (failure) => emit(PrivacyError(failure.message)),
        (_) => emit(PrivacyLoaded(current, successMessage: 'Local data cleared successfully')),
      );
    }
  }

  Future<void> _onDeleteAIHistory(DeleteAIHistoryEvent event, Emitter<PrivacyState> emit) async {
    if (state is PrivacyLoaded) {
      final current = (state as PrivacyLoaded).privacy;
      emit(PrivacyLoading());
      final res = await repository.deleteAIHistory();
      res.fold(
        (failure) => emit(PrivacyError(failure.message)),
        (_) => emit(PrivacyLoaded(current, successMessage: 'AI history deleted successfully')),
      );
    }
  }
}
