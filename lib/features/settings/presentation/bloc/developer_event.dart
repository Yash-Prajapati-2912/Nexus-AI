import 'package:equatable/equatable.dart';

abstract class DeveloperEvent extends Equatable {
  const DeveloperEvent();

  @override
  List<Object?> get props => [];
}

class ChangeEnvironmentEvent extends DeveloperEvent {
  final String env;
  final String baseUrl;
  const ChangeEnvironmentEvent(this.env, this.baseUrl);

  @override
  List<Object?> get props => [env, baseUrl];
}

class ToggleNetworkLogsEvent extends DeveloperEvent {
  final bool enable;
  const ToggleNetworkLogsEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class ToggleFeatureFlagEvent extends DeveloperEvent {
  final String flagKey;
  final bool isEnabled;
  const ToggleFeatureFlagEvent(this.flagKey, this.isEnabled);

  @override
  List<Object?> get props => [flagKey, isEnabled];
}

class TogglePerformanceOverlayEvent extends DeveloperEvent {
  final bool enable;
  const TogglePerformanceOverlayEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}
