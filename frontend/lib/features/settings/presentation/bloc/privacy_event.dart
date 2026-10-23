import 'package:equatable/equatable.dart';

abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object?> get props => [];
}

class ToggleAnalyticsConsentEvent extends PrivacyEvent {
  final bool enable;
  const ToggleAnalyticsConsentEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class ToggleCrashReportingEvent extends PrivacyEvent {
  final bool enable;
  const ToggleCrashReportingEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class ToggleAIDataUsageEvent extends PrivacyEvent {
  final bool enable;
  const ToggleAIDataUsageEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}

class ClearAppCacheEvent extends PrivacyEvent {}

class ClearLocalDataEvent extends PrivacyEvent {}

class DeleteAIHistoryEvent extends PrivacyEvent {}
