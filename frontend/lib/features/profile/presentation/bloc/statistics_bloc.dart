import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/user_statistics.dart';
import '../../domain/usecases/load_statistics_usecase.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadStatisticsEvent extends StatisticsEvent {
  const LoadStatisticsEvent();
}

abstract class StatisticsState extends Equatable {
  const StatisticsState();
  @override
  List<Object?> get props => [];
}

class StatisticsInitialState extends StatisticsState {
  const StatisticsInitialState();
}

class StatisticsLoadingState extends StatisticsState {
  const StatisticsLoadingState();
}

class StatisticsLoadedState extends StatisticsState {
  final UserStatistics statistics;
  const StatisticsLoadedState(this.statistics);
  @override
  List<Object?> get props => [statistics];
}

class StatisticsFailureState extends StatisticsState {
  final String message;
  const StatisticsFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final LoadStatisticsUseCase loadStatisticsUseCase;

  StatisticsBloc({required this.loadStatisticsUseCase}) : super(const StatisticsInitialState()) {
    on<LoadStatisticsEvent>((event, emit) async {
      emit(const StatisticsLoadingState());
      final res = await loadStatisticsUseCase(const NoParams());
      res.fold(
        (Failure f) => emit(StatisticsFailureState(f.message)),
        (stats) => emit(StatisticsLoadedState(stats)),
      );
    });
  }
}
