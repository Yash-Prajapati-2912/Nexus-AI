import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;

  DashboardBloc({
    required GetDashboardUseCase getDashboardUseCase,
  })  : _getDashboardUseCase = getDashboardUseCase,
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
    final result = await _getDashboardUseCase(const NoParams());
    result.fold(
      (failure) => emit(DashboardErrorState(failure.message)),
      (dashboard) => emit(DashboardLoadedState(dashboard)),
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoadedState) {
      final current = (state as DashboardLoadedState).dashboard;
      emit(DashboardRefreshingState(current));
    }
    final result = await _getDashboardUseCase(const NoParams());
    result.fold(
      (failure) => emit(DashboardErrorState(failure.message)),
      (dashboard) => emit(DashboardLoadedState(dashboard)),
    );
  }
}
