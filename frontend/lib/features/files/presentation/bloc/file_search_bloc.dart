import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/usecases/search_files_usecase.dart';

abstract class FileSearchEvent extends Equatable {
  const FileSearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryEvent extends FileSearchEvent {
  final String query;
  const SearchQueryEvent(this.query);
  @override
  List<Object?> get props => [query];
}

abstract class FileSearchState extends Equatable {
  const FileSearchState();
  @override
  List<Object?> get props => [];
}

class FileSearchInitialState extends FileSearchState {
  const FileSearchInitialState();
}

class FileSearchLoadingState extends FileSearchState {
  const FileSearchLoadingState();
}

class FileSearchLoadedState extends FileSearchState {
  final List<FileItem> results;
  const FileSearchLoadedState(this.results);
  @override
  List<Object?> get props => [results];
}

class FileSearchFailureState extends FileSearchState {
  final String message;
  const FileSearchFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class FileSearchBloc extends Bloc<FileSearchEvent, FileSearchState> {
  final SearchFilesUseCase searchFilesUseCase;

  FileSearchBloc({required this.searchFilesUseCase}) : super(const FileSearchInitialState()) {
    on<SearchQueryEvent>((event, emit) async {
      if (event.query.trim().isEmpty) {
        emit(const FileSearchLoadedState([]));
        return;
      }
      emit(const FileSearchLoadingState());
      final res = await searchFilesUseCase(event.query);
      res.fold(
        (Failure f) => emit(FileSearchFailureState(f.message)),
        (results) => emit(FileSearchLoadedState(results)),
      );
    });
  }
}
