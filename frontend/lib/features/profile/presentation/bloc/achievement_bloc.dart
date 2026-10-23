import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/i_profile_repository.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();
  @override
  List<Object?> get props => [];
}

class LoadAchievementsEvent extends AchievementEvent {
  const LoadAchievementsEvent();
}

abstract class AchievementState extends Equatable {
  const AchievementState();
  @override
  List<Object?> get props => [];
}

class AchievementInitialState extends AchievementState {
  const AchievementInitialState();
}

class AchievementLoadingState extends AchievementState {
  const AchievementLoadingState();
}

class AchievementLoadedState extends AchievementState {
  final List<Achievement> achievements;
  const AchievementLoadedState(this.achievements);
  @override
  List<Object?> get props => [achievements];
}

class AchievementFailureState extends AchievementState {
  final String message;
  const AchievementFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final IProfileRepository repository;

  AchievementBloc({required this.repository}) : super(const AchievementInitialState()) {
    on<LoadAchievementsEvent>((event, emit) async {
      emit(const AchievementLoadingState());
      final res = await repository.getAchievements();
      res.fold(
        (Failure f) => emit(AchievementFailureState(f.message)),
        (list) => emit(AchievementLoadedState(list)),
      );
    });
  }
}
