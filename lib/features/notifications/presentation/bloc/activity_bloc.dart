import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/activity_item.dart';
import '../../domain/usecases/get_activity_usecase.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
  @override
  List<Object?> get props => [];
}

class LoadActivityTimelineEvent extends ActivityEvent {
  const LoadActivityTimelineEvent();
}

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object?> get props => [];
}

class ActivityInitialState extends ActivityState {
  const ActivityInitialState();
}

class ActivityLoadingState extends ActivityState {
  const ActivityLoadingState();
}

class ActivityLoadedState extends ActivityState {
  final List<ActivityItem> activities;
  const ActivityLoadedState(this.activities);
  @override
  List<Object?> get props => [activities];
}

class ActivityFailureState extends ActivityState {
  final String message;
  const ActivityFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivityUseCase getActivityUseCase;

  ActivityBloc({required this.getActivityUseCase}) : super(const ActivityInitialState()) {
    on<LoadActivityTimelineEvent>((event, emit) async {
      emit(const ActivityLoadingState());
      final res = await getActivityUseCase(const NoParams());
      res.fold(
        (Failure f) => emit(ActivityFailureState(f.message)),
        (list) => emit(ActivityLoadedState(list)),
      );
    });
  }
}
