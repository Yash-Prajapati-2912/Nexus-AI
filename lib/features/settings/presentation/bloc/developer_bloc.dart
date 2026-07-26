import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/developer_settings_entity.dart';
import '../../domain/usecases/update_developer_settings_usecase.dart';
import 'developer_event.dart';
import 'developer_state.dart';

class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  final UpdateDeveloperSettingsUseCase updateDeveloperSettingsUseCase;

  DeveloperBloc({
    required this.updateDeveloperSettingsUseCase,
  }) : super(DeveloperLoaded(DeveloperSettingsEntity.initial())) {
    on<ChangeEnvironmentEvent>(_onChangeEnvironment);
    on<ToggleNetworkLogsEvent>(_onToggleNetworkLogs);
    on<ToggleFeatureFlagEvent>(_onToggleFeatureFlag);
    on<TogglePerformanceOverlayEvent>(_onTogglePerformanceOverlay);
  }

  Future<void> _onChangeEnvironment(ChangeEnvironmentEvent event, Emitter<DeveloperState> emit) async {
    if (state is DeveloperLoaded) {
      final current = (state as DeveloperLoaded).settings;
      final updated = current.copyWith(
        environment: event.env,
        apiBaseUrl: event.baseUrl,
      );
      await updateDeveloperSettingsUseCase(updated);
      emit(DeveloperLoaded(updated, toast: 'Switched environment to ${event.env}'));
    }
  }

  Future<void> _onToggleNetworkLogs(ToggleNetworkLogsEvent event, Emitter<DeveloperState> emit) async {
    if (state is DeveloperLoaded) {
      final current = (state as DeveloperLoaded).settings;
      final updated = current.copyWith(enableNetworkLogs: event.enable);
      await updateDeveloperSettingsUseCase(updated);
      emit(DeveloperLoaded(updated, toast: 'Network logging updated'));
    }
  }

  Future<void> _onToggleFeatureFlag(ToggleFeatureFlagEvent event, Emitter<DeveloperState> emit) async {
    if (state is DeveloperLoaded) {
      final current = (state as DeveloperLoaded).settings;
      final updatedFlags = Map<String, bool>.from(current.featureFlags);
      updatedFlags[event.flagKey] = event.isEnabled;
      final updated = current.copyWith(featureFlags: updatedFlags);
      await updateDeveloperSettingsUseCase(updated);
      emit(DeveloperLoaded(updated, toast: 'Feature flag ${event.flagKey} updated'));
    }
  }

  Future<void> _onTogglePerformanceOverlay(
      TogglePerformanceOverlayEvent event, Emitter<DeveloperState> emit) async {
    if (state is DeveloperLoaded) {
      final current = (state as DeveloperLoaded).settings;
      final updated = current.copyWith(showPerformanceOverlay: event.enable);
      await updateDeveloperSettingsUseCase(updated);
      emit(DeveloperLoaded(updated, toast: 'Performance overlay updated'));
    }
  }
}
