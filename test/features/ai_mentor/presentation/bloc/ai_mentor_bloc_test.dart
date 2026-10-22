import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/student_wellness.dart';
import 'package:nexus_ai/features/ai_mentor/domain/repositories/i_ai_mentor_repository.dart';
import 'package:nexus_ai/features/ai_mentor/domain/usecases/get_wellness_scores_usecase.dart';
import 'package:nexus_ai/features/ai_mentor/domain/usecases/load_conversations_usecase.dart';
import 'package:nexus_ai/features/ai_mentor/presentation/bloc/ai_mentor_bloc.dart';

class MockGetWellnessScoresUseCase extends Mock implements GetWellnessScoresUseCase {}
class MockLoadConversationsUseCase extends Mock implements LoadConversationsUseCase {}
class MockAIMentorRepository extends Mock implements IAIMentorRepository {}

void main() {
  late AIMentorBloc bloc;
  late MockGetWellnessScoresUseCase mockGetWellnessScoresUseCase;
  late MockLoadConversationsUseCase mockLoadConversationsUseCase;
  late MockAIMentorRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetWellnessScoresUseCase = MockGetWellnessScoresUseCase();
    mockLoadConversationsUseCase = MockLoadConversationsUseCase();
    mockRepository = MockAIMentorRepository();

    bloc = AIMentorBloc(
      getWellnessScoresUseCase: mockGetWellnessScoresUseCase,
      loadConversationsUseCase: mockLoadConversationsUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tWellness = StudentWellness(
    overallWellnessScore: 88,
    academicPerformanceScore: 85,
    financialWellnessScore: 90,
    productivityScore: 84,
    careerReadinessScore: 82,
    goalProgressScore: 86,
    habitConsistencyScore: 89,
    wellnessLevel: 'BALANCED',
    keyRecommendations: ['Keep going'],
  );

  test('initial state should be AIMentorInitialState', () {
    expect(bloc.state, equals(const AIMentorInitialState()));
  });

  blocTest<AIMentorBloc, AIMentorState>(
    'emits [AIMentorLoadingState, AIMentorLoadedState] when LoadAIMentorDashboardEvent is added',
    build: () {
      when(() => mockGetWellnessScoresUseCase(any())).thenAnswer((_) async => const Right(tWellness));
      when(() => mockLoadConversationsUseCase(any())).thenAnswer((_) async => const Right([]));
      when(() => mockRepository.getSuggestedPrompts()).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (b) => b.add(const LoadAIMentorDashboardEvent()),
    expect: () => [
      const AIMentorLoadingState(),
      isA<AIMentorLoadedState>(),
    ],
    verify: (b) {
      final state = b.state as AIMentorLoadedState;
      expect(state.wellness, equals(tWellness));
    },
  );

  blocTest<AIMentorBloc, AIMentorState>(
    'does NOT fabricate wellness metrics when wellness score retrieval fails',
    build: () {
      when(() => mockGetWellnessScoresUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Wellness unavailable')));
      when(() => mockLoadConversationsUseCase(any())).thenAnswer((_) async => const Right([]));
      when(() => mockRepository.getSuggestedPrompts()).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (b) => b.add(const LoadAIMentorDashboardEvent()),
    expect: () => [
      const AIMentorLoadingState(),
      isA<AIMentorLoadedState>(),
    ],
    verify: (b) {
      final state = b.state as AIMentorLoadedState;
      expect(state.wellness, isNull); // Verify no fake fallback scores are substituted
    },
  );
}

