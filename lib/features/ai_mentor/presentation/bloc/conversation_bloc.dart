import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/usecases/load_conversation_details_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/update_conversation_usecase.dart';

// EVENTS
abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversationEvent extends ConversationEvent {
  final String conversationId;
  const LoadConversationEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class SendChatMessageEvent extends ConversationEvent {
  final String conversationId;
  final String content;
  final String? topic;

  const SendChatMessageEvent({required this.conversationId, required this.content, this.topic});

  @override
  List<Object?> get props => [conversationId, content, topic];
}

class TogglePinConversationEvent extends ConversationEvent {
  final String conversationId;
  final bool currentPinState;

  const TogglePinConversationEvent({required this.conversationId, required this.currentPinState});

  @override
  List<Object?> get props => [conversationId, currentPinState];
}

class RenameConversationEvent extends ConversationEvent {
  final String conversationId;
  final String newTitle;

  const RenameConversationEvent({required this.conversationId, required this.newTitle});

  @override
  List<Object?> get props => [conversationId, newTitle];
}

// STATES
abstract class ConversationState extends Equatable {
  const ConversationState();
  @override
  List<Object?> get props => [];
}

class ConversationInitialState extends ConversationState {
  const ConversationInitialState();
}

class ConversationLoadingState extends ConversationState {
  const ConversationLoadingState();
}

class ConversationFailureState extends ConversationState {
  final String message;
  const ConversationFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class ConversationLoadedState extends ConversationState {
  final Conversation conversation;
  final List<ChatMessage> messages;
  final bool isSending;

  const ConversationLoadedState({
    required this.conversation,
    required this.messages,
    this.isSending = false,
  });

  ConversationLoadedState copyWith({
    Conversation? conversation,
    List<ChatMessage>? messages,
    bool? isSending,
  }) {
    return ConversationLoadedState(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [conversation, messages, isSending];
}

// BLOC
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final SendMessageUseCase sendMessageUseCase;
  final LoadConversationDetailsUseCase loadConversationDetailsUseCase;
  final UpdateConversationUseCase updateConversationUseCase;

  ConversationBloc({
    required this.sendMessageUseCase,
    required this.loadConversationDetailsUseCase,
    required this.updateConversationUseCase,
  }) : super(const ConversationInitialState()) {
    on<LoadConversationEvent>(_onLoadConversation);
    on<SendChatMessageEvent>(_onSendMessage);
    on<TogglePinConversationEvent>(_onTogglePin);
    on<RenameConversationEvent>(_onRename);
  }

  Future<void> _onLoadConversation(LoadConversationEvent event, Emitter<ConversationState> emit) async {
    emit(const ConversationLoadingState());
    final res = await loadConversationDetailsUseCase(event.conversationId);
    res.fold(
      (Failure f) => emit(ConversationFailureState(f.message)),
      (conv) => emit(ConversationLoadedState(conversation: conv, messages: const [])),
    );
  }

  Future<void> _onSendMessage(SendChatMessageEvent event, Emitter<ConversationState> emit) async {
    if (state is ConversationLoadedState) {
      final currentState = state as ConversationLoadedState;
      final userMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: event.conversationId,
        sender: 'USER',
        content: event.content,
        createdAt: DateTime.now(),
      );

      final updatedMessages = List<ChatMessage>.from(currentState.messages)..add(userMsg);
      emit(currentState.copyWith(messages: updatedMessages, isSending: true));

      final res = await sendMessageUseCase(SendMessageParams(
        conversationId: event.conversationId,
        content: event.content,
        topic: event.topic,
      ));

      res.fold(
        (Failure f) => emit(currentState.copyWith(isSending: false)),
        (aiMsg) {
          final finalMessages = List<ChatMessage>.from(updatedMessages)..add(aiMsg);
          emit(currentState.copyWith(messages: finalMessages, isSending: false));
        },
      );
    }
  }

  Future<void> _onTogglePin(TogglePinConversationEvent event, Emitter<ConversationState> emit) async {
    if (state is ConversationLoadedState) {
      final currentState = state as ConversationLoadedState;
      final res = await updateConversationUseCase(UpdateConversationParams(
        conversationId: event.conversationId,
        isPinned: !event.currentPinState,
      ));
      res.fold(
        (_) {},
        (updatedConv) => emit(currentState.copyWith(conversation: updatedConv)),
      );
    }
  }

  Future<void> _onRename(RenameConversationEvent event, Emitter<ConversationState> emit) async {
    if (state is ConversationLoadedState) {
      final currentState = state as ConversationLoadedState;
      final res = await updateConversationUseCase(UpdateConversationParams(
        conversationId: event.conversationId,
        title: event.newTitle,
      ));
      res.fold(
        (_) {},
        (updatedConv) => emit(currentState.copyWith(conversation: updatedConv)),
      );
    }
  }
}
