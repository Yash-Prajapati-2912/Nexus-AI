import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/prompt_template.dart';
import '../../domain/entities/student_wellness.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';
import '../../domain/usecases/get_wellness_scores_usecase.dart';
import '../../domain/usecases/load_conversations_usecase.dart';

// EVENTS
abstract class AIMentorEvent extends Equatable {
  const AIMentorEvent();
  @override
  List<Object?> get props => [];
}

class LoadAIMentorDashboardEvent extends AIMentorEvent {
  const LoadAIMentorDashboardEvent();
}

class RefreshAIMentorDashboardEvent extends AIMentorEvent {
  const RefreshAIMentorDashboardEvent();
}

// STATES
abstract class AIMentorState extends Equatable {
  const AIMentorState();
  @override
  List<Object?> get props => [];
}

class AIMentorInitialState extends AIMentorState {
  const AIMentorInitialState();
}

class AIMentorLoadingState extends AIMentorState {
  const AIMentorLoadingState();
}

class AIMentorFailureState extends AIMentorState {
  final String message;
  const AIMentorFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class AIMentorLoadedState extends AIMentorState {
  final StudentWellness wellness;
  final List<Conversation> recentConversations;
  final List<Conversation> pinnedConversations;
  final List<PromptTemplate> suggestedPrompts;

  const AIMentorLoadedState({
    required this.wellness,
    required this.recentConversations,
    required this.pinnedConversations,
    required this.suggestedPrompts,
  });

  @override
  List<Object?> get props => [wellness, recentConversations, pinnedConversations, suggestedPrompts];
}

// BLOC
class AIMentorBloc extends Bloc<AIMentorEvent, AIMentorState> {
  final GetWellnessScoresUseCase getWellnessScoresUseCase;
  final LoadConversationsUseCase loadConversationsUseCase;
  final IAIMentorRepository repository;

  AIMentorBloc({
    required this.getWellnessScoresUseCase,
    required this.loadConversationsUseCase,
    required this.repository,
  }) : super(const AIMentorInitialState()) {
    on<LoadAIMentorDashboardEvent>(_onLoadDashboard);
    on<RefreshAIMentorDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(LoadAIMentorDashboardEvent event, Emitter<AIMentorState> emit) async {
    emit(const AIMentorLoadingState());

    try {
      final wellnessRes = await getWellnessScoresUseCase(const NoParams());
      final convsRes = await loadConversationsUseCase(const NoParams());
      final promptsRes = await repository.getSuggestedPrompts();

      final wellness = wellnessRes.getOrElse((_) => const StudentWellness(
            overallWellnessScore: 86,
            academicPerformanceScore: 82,
            financialWellnessScore: 84,
            productivityScore: 88,
            careerReadinessScore: 78,
            goalProgressScore: 85,
            habitConsistencyScore: 89,
            wellnessLevel: 'BALANCED',
            keyRecommendations: [
              'Maintain study schedule consistency',
              'Schedule 1 hour outdoor break daily',
            ],
          ));

      final convs = convsRes.getOrElse((_) => []);
      final prompts = promptsRes.getOrElse((_) => []);
      final pinned = convs.where((c) => c.isPinned).toList();

      emit(AIMentorLoadedState(
        wellness: wellness,
        recentConversations: convs,
        pinnedConversations: pinned,
        suggestedPrompts: prompts,
      ));
    } catch (e) {
      emit(AIMentorFailureState(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(RefreshAIMentorDashboardEvent event, Emitter<AIMentorState> emit) async {
    add(const LoadAIMentorDashboardEvent());
  }
}
