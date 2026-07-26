import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/prompt_template.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';

abstract class PromptEvent extends Equatable {
  const PromptEvent();
  @override
  List<Object?> get props => [];
}

class LoadPromptsEvent extends PromptEvent {
  const LoadPromptsEvent();
}

abstract class PromptState extends Equatable {
  const PromptState();
  @override
  List<Object?> get props => [];
}

class PromptInitialState extends PromptState {
  const PromptInitialState();
}

class PromptLoadingState extends PromptState {
  const PromptLoadingState();
}

class PromptLoadedState extends PromptState {
  final List<PromptTemplate> prompts;
  const PromptLoadedState(this.prompts);
  @override
  List<Object?> get props => [prompts];
}

class PromptFailureState extends PromptState {
  final String message;
  const PromptFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final IAIMentorRepository repository;

  PromptBloc({required this.repository}) : super(const PromptInitialState()) {
    on<LoadPromptsEvent>((event, emit) async {
      emit(const PromptLoadingState());
      final res = await repository.getSuggestedPrompts();
      res.fold(
        (Failure f) => emit(PromptFailureState(f.message)),
        (prompts) => emit(PromptLoadedState(prompts)),
      );
    });
  }
}
