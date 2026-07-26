import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../../domain/usecases/update_notification_preferences_usecase.dart';

abstract class NotificationPreferenceEvent extends Equatable {
  const NotificationPreferenceEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationPreferencesEvent extends NotificationPreferenceEvent {
  const LoadNotificationPreferencesEvent();
}

class UpdatePreferencesSubmitEvent extends NotificationPreferenceEvent {
  final Map<String, dynamic> body;
  const UpdatePreferencesSubmitEvent(this.body);
  @override
  List<Object?> get props => [body];
}

abstract class NotificationPreferenceState extends Equatable {
  const NotificationPreferenceState();
  @override
  List<Object?> get props => [];
}

class NotificationPreferenceInitialState extends NotificationPreferenceState {
  const NotificationPreferenceInitialState();
}

class NotificationPreferenceLoadingState extends NotificationPreferenceState {
  const NotificationPreferenceLoadingState();
}

class NotificationPreferenceLoadedState extends NotificationPreferenceState {
  final NotificationPreferences preferences;
  const NotificationPreferenceLoadedState(this.preferences);
  @override
  List<Object?> get props => [preferences];
}

class NotificationPreferenceFailureState extends NotificationPreferenceState {
  final String message;
  const NotificationPreferenceFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationPreferenceBloc extends Bloc<NotificationPreferenceEvent, NotificationPreferenceState> {
  final UpdateNotificationPreferencesUseCase updateNotificationPreferencesUseCase;
  final INotificationRepository repository;

  NotificationPreferenceBloc({
    required this.updateNotificationPreferencesUseCase,
    required this.repository,
  }) : super(const NotificationPreferenceInitialState()) {
    on<LoadNotificationPreferencesEvent>(_onLoad);
    on<UpdatePreferencesSubmitEvent>(_onUpdate);
  }

  Future<void> _onLoad(LoadNotificationPreferencesEvent event, Emitter<NotificationPreferenceState> emit) async {
    emit(const NotificationPreferenceLoadingState());
    final res = await repository.getPreferences();
    res.fold(
      (Failure f) => emit(NotificationPreferenceFailureState(f.message)),
      (prefs) => emit(NotificationPreferenceLoadedState(prefs)),
    );
  }

  Future<void> _onUpdate(UpdatePreferencesSubmitEvent event, Emitter<NotificationPreferenceState> emit) async {
    final res = await updateNotificationPreferencesUseCase(event.body);
    res.fold(
      (Failure f) => emit(NotificationPreferenceFailureState(f.message)),
      (prefs) => emit(NotificationPreferenceLoadedState(prefs)),
    );
  }
}
