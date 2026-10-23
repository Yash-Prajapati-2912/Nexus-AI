import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/usecases/search_conversations_usecase.dart';

abstract class MentorSearchEvent extends Equatable {
  const MentorSearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends MentorSearchEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

abstract class MentorSearchState extends Equatable {
  const MentorSearchState();
  @override
  List<Object?> get props => [];
}

class MentorSearchInitialState extends MentorSearchState {
  const MentorSearchInitialState();
}

class MentorSearchLoadingState extends MentorSearchState {
  const MentorSearchLoadingState();
}

class MentorSearchLoadedState extends MentorSearchState {
  final List<Conversation> results;
  const MentorSearchLoadedState(this.results);
  @override
  List<Object?> get props => [results];
}

class MentorSearchFailureState extends MentorSearchState {
  final String message;
  const MentorSearchFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class MentorSearchBloc extends Bloc<MentorSearchEvent, MentorSearchState> {
  final SearchConversationsUseCase searchConversationsUseCase;

  MentorSearchBloc({required this.searchConversationsUseCase}) : super(const MentorSearchInitialState()) {
    on<SearchQueryChangedEvent>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(const MentorSearchInitialState());
        return;
      }
      emit(const MentorSearchLoadingState());
      final res = await searchConversationsUseCase(event.query);
      res.fold(
        (Failure f) => emit(MentorSearchFailureState(f.message)),
        (results) => emit(MentorSearchLoadedState(results)),
      );
    });
  }
}
