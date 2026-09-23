import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../../../planner/domain/usecases/get_planner_usecase.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;
  final GetPlannerUseCase _getPlannerUseCase;

  DashboardBloc({
    required GetDashboardUseCase getDashboardUseCase,
    required GetPlannerUseCase getPlannerUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase,
        _getPlannerUseCase = getPlannerUseCase,
        super(DashboardInitialState()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<RetryLoadDashboardEvent>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoadingState());
    final results = await Future.wait([
      _getDashboardUseCase(const NoParams()),
      _getPlannerUseCase(const NoParams()),
    ]);

    final dashboardResult = results[0] as Either<Failure, DashboardEntity>;
    final tasksResult = results[1] as Either<Failure, List<TaskEntity>>;

    dashboardResult.fold(
      (failure) => emit(DashboardErrorState(failure.message)),
      (dashboard) {
        final tasks = tasksResult.getOrElse((_) => <TaskEntity>[]);
        emit(DashboardLoadedState(dashboard, tasks: tasks));
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoadedState) {
      final current = (state as DashboardLoadedState).dashboard;
      final currentTasks = (state as DashboardLoadedState).tasks;
      emit(DashboardRefreshingState(current, currentTasks: currentTasks));
    }
    final results = await Future.wait([
      _getDashboardUseCase(const NoParams()),
      _getPlannerUseCase(const NoParams()),
    ]);

    final dashboardResult = results[0] as Either<Failure, DashboardEntity>;
    final tasksResult = results[1] as Either<Failure, List<TaskEntity>>;

    dashboardResult.fold(
      (failure) => emit(DashboardErrorState(failure.message)),
      (dashboard) {
        final tasks = tasksResult.getOrElse((_) => <TaskEntity>[]);
        emit(DashboardLoadedState(dashboard, tasks: tasks));
      },
    );
  }
}
