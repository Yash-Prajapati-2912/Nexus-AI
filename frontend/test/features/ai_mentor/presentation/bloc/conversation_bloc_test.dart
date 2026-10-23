import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/chat_message.dart';
import 'package:nexus_ai/features/ai_mentor/domain/entities/conversation.dart';
import 'package:nexus_ai/features/ai_mentor/domain/usecases/load_conversation_details_usecase.dart';
import 'package:nexus_ai/features/ai_mentor/domain/usecases/send_message_usecase.dart';
import 'package:nexus_ai/features/ai_mentor/domain/usecases/update_conversation_usecase.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/ai_mentor/presentation/bloc/conversation_bloc.dart';

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockLoadConversationDetailsUseCase extends Mock implements LoadConversationDetailsUseCase {}
class MockUpdateConversationUseCase extends Mock implements UpdateConversationUseCase {}

void main() {
  late ConversationBloc bloc;
  late MockSendMessageUseCase mockSendMessageUseCase;
  late MockLoadConversationDetailsUseCase mockLoadConversationDetailsUseCase;
  late MockUpdateConversationUseCase mockUpdateConversationUseCase;

  setUpAll(() {
    registerFallbackValue(const SendMessageParams(conversationId: 'c1', content: 'test'));
  });

  setUp(() {
    mockSendMessageUseCase = MockSendMessageUseCase();
    mockLoadConversationDetailsUseCase = MockLoadConversationDetailsUseCase();
    mockUpdateConversationUseCase = MockUpdateConversationUseCase();

    bloc = ConversationBloc(
      sendMessageUseCase: mockSendMessageUseCase,
      loadConversationDetailsUseCase: mockLoadConversationDetailsUseCase,
      updateConversationUseCase: mockUpdateConversationUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tMsg1 = ChatMessage(
    id: 'm1',
    conversationId: 'c-100',
    sender: 'USER',
    content: 'How should I study for exams?',
    createdAt: DateTime(2026, 7, 10, 10, 0),
  );

  final tMsg2 = ChatMessage(
    id: 'm2',
    conversationId: 'c-100',
    sender: 'AI',
    content: 'Create a structured daily schedule.',
    createdAt: DateTime(2026, 7, 10, 10, 1),
  );

  final tConversation = Conversation(
    id: 'c-100',
    title: 'Exam Study Strategy',
    createdAt: DateTime(2026, 7, 10),
    updatedAt: DateTime(2026, 7, 10),
    messageCount: 2,
    lastMessageSnippet: 'Create a structured daily schedule.',
    topic: 'STUDY',
    messages: [tMsg1, tMsg2],
  );

  test('initial state is ConversationInitialState', () {
    expect(bloc.state, equals(const ConversationInitialState()));
  });

  blocTest<ConversationBloc, ConversationState>(
    'LoadConversationEvent retrieves and emits persisted messages in order',
    build: () {
      when(() => mockLoadConversationDetailsUseCase('c-100'))
          .thenAnswer((_) async => Right(tConversation));
      return bloc;
    },
    act: (b) => b.add(const LoadConversationEvent('c-100')),
    expect: () => [
      const ConversationLoadingState(),
      ConversationLoadedState(
        conversation: tConversation,
        messages: [tMsg1, tMsg2],
      ),
    ],
  );

  blocTest<ConversationBloc, ConversationState>(
    'SendChatMessageEvent appends to existing messages and preserves conversation continuity',
    build: () {
      when(() => mockSendMessageUseCase(any())).thenAnswer((_) async => Right(ChatMessage(
            id: 'm3',
            conversationId: 'c-100',
            sender: 'AI',
            content: 'Take regular 15-minute breaks.',
            createdAt: DateTime.now(),
          )));
      return bloc;
    },
    seed: () => ConversationLoadedState(
      conversation: tConversation,
      messages: [tMsg1, tMsg2],
    ),
    act: (b) => b.add(const SendChatMessageEvent(
      conversationId: 'c-100',
      content: 'What about breaks?',
      topic: 'STUDY',
    )),
    verify: (b) {
      final state = b.state as ConversationLoadedState;
      expect(state.conversation.id, equals('c-100'));
      expect(state.messages.length, equals(4)); // tMsg1, tMsg2, user turn, AI turn
      expect(state.messages[2].content, equals('What about breaks?'));
      expect(state.messages[3].content, equals('Take regular 15-minute breaks.'));
    },
  );

  blocTest<ConversationBloc, ConversationState>(
    'SendChatMessageEvent with null conversationId starts new conversation without placeholder',
    build: () {
      when(() => mockSendMessageUseCase(any())).thenAnswer((_) async => Right(ChatMessage(
            id: 'm-new-1',
            conversationId: 'c-created-999',
            sender: 'AI',
            content: 'Revision strategy created.',
            createdAt: DateTime.now(),
          )));
      return bloc;
    },
    act: (b) => b.add(const SendChatMessageEvent(
      conversationId: null,
      content: 'Structure my revision',
      topic: 'STUDY',
    )),
    verify: (b) {
      final state = b.state as ConversationLoadedState;
      expect(state.conversation.id, equals('c-created-999'));
      expect(state.conversation.topic, equals('STUDY'));
      expect(state.messages.length, equals(2));
      verify(() => mockSendMessageUseCase(any(that: predicate<SendMessageParams>((p) =>
          p.conversationId == '' && p.content == 'Structure my revision' && p.topic == 'STUDY')))).called(1);
    },
  );

  blocTest<ConversationBloc, ConversationState>(
    'SendChatMessageEvent is ignored when isSending is already true (duplicate prevention)',
    build: () => bloc,
    seed: () => ConversationLoadedState(
      conversation: tConversation,
      messages: [tMsg1],
      isSending: true,
    ),
    act: (b) => b.add(const SendChatMessageEvent(
      conversationId: 'c-100',
      content: 'Duplicate message',
    )),
    expect: () => [], // No states emitted because duplicate is prevented
  );

  blocTest<ConversationBloc, ConversationState>(
    'LoadConversationEvent emits ConversationFailureState when repository fails',
    build: () {
      when(() => mockLoadConversationDetailsUseCase('c-fail'))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Conversation not found')));
      return bloc;
    },
    act: (b) => b.add(const LoadConversationEvent('c-fail')),
    expect: () => [
      const ConversationLoadingState(),
      const ConversationFailureState('Conversation not found'),
    ],
  );
}

