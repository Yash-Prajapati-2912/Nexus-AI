import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_preferences_entity.dart';
import '../../domain/entities/notification_preference_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateAIPreferencesEvent extends SettingsEvent {
  final AIPreferencesEntity preferences;
  const UpdateAIPreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class UpdateNotificationPreferencesEvent extends SettingsEvent {
  final NotificationPreferenceEntity preferences;
  const UpdateNotificationPreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
