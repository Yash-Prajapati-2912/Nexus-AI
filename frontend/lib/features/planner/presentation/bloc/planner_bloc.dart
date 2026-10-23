import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/complete_task_usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_planner_usecase.dart';
import '../../domain/usecases/search_planner_usecase.dart';
import 'planner_event.dart';
import 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final GetPlannerUseCase _getPlannerUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final SearchPlannerUseCase _searchPlannerUseCase;

  PlannerBloc({
    required GetPlannerUseCase getPlannerUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required CompleteTaskUseCase completeTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required SearchPlannerUseCase searchPlannerUseCase,
  })  : _getPlannerUseCase = getPlannerUseCase,
        _createTaskUseCase = createTaskUseCase,
        _completeTaskUseCase = completeTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _searchPlannerUseCase = searchPlannerUseCase,
        super(PlannerInitialState()) {
    on<LoadPlannerEvent>(_onLoadPlanner);
    on<CreateTaskEvent>(_onCreateTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<SearchPlannerEvent>(_onSearchPlanner);
    on<UpdateTaskEvent>(_onUpdateTask);
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    final result = await _createTaskUseCase(event.task);
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (_) => add(LoadPlannerEvent()),
    );
  }

  Future<void> _onLoadPlanner(
    LoadPlannerEvent event,
    Emitter<PlannerState> emit,
  ) async {
    emit(PlannerLoadingState());
    final result = await _getPlannerUseCase(const NoParams());
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (tasks) => emit(
        PlannerLoadedState(
          tasks: tasks,
          assignments: const [],
          sessions: const [],
          goals: const [],
        ),
      ),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    final result = await _createTaskUseCase(event.task);
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (_) => add(LoadPlannerEvent()),
    );
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<PlannerState> emit,
  ) async {
    final result = await _completeTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (_) => add(LoadPlannerEvent()),
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<PlannerState> emit,
  ) async {
    final result = await _deleteTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (_) => add(LoadPlannerEvent()),
    );
  }

  Future<void> _onSearchPlanner(
    SearchPlannerEvent event,
    Emitter<PlannerState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadPlannerEvent());
      return;
    }
    emit(PlannerLoadingState());
    final result = await _searchPlannerUseCase(event.query);
    result.fold(
      (failure) => emit(PlannerErrorState(failure.message)),
      (tasks) => emit(
        PlannerLoadedState(
          tasks: tasks,
          assignments: const [],
          sessions: const [],
          goals: const [],
        ),
      ),
    );
  }
}
