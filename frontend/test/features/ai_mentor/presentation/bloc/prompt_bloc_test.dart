import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/prompt_template.dart';
import 'package:nexus_ai/features/ai_mentor/domain/repositories/i_ai_mentor_repository.dart';
import 'package:nexus_ai/features/ai_mentor/presentation/bloc/prompt_bloc.dart';

class MockAIMentorRepository extends Mock implements IAIMentorRepository {}

void main() {
  late PromptBloc bloc;
  late MockAIMentorRepository mockRepository;

  setUp(() {
    mockRepository = MockAIMentorRepository();
    bloc = PromptBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  const tPrompts = [
    PromptTemplate(
      id: 'p1',
      title: 'Exam Strategy',
      category: 'STUDY',
      promptText: 'How should I study for exams?',
    ),
    PromptTemplate(
      id: 'p2',
      title: 'Budget Analysis',
      category: 'FINANCE',
      promptText: 'Analyze my spending.',
    ),
  ];

  test('initial state should be PromptInitialState', () {
    expect(bloc.state, equals(const PromptInitialState()));
  });

  blocTest<PromptBloc, PromptState>(
    'emits [PromptLoadingState, PromptLoadedState] when repository returns prompts successfully',
    build: () {
      when(() => mockRepository.getSuggestedPrompts())
          .thenAnswer((_) async => const Right(tPrompts));
      return bloc;
    },
    act: (b) => b.add(const LoadPromptsEvent()),
    expect: () => [
      const PromptLoadingState(),
      const PromptLoadedState(tPrompts),
    ],
  );

  blocTest<PromptBloc, PromptState>(
    'emits [PromptLoadingState, PromptFailureState] when repository returns failure',
    build: () {
      when(() => mockRepository.getSuggestedPrompts())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Failed to load prompts')));
      return bloc;
    },
    act: (b) => b.add(const LoadPromptsEvent()),
    expect: () => [
      const PromptLoadingState(),
      const PromptFailureState('Failed to load prompts'),
    ],
  );
}
