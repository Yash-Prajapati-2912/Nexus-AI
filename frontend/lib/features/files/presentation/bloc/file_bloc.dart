import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/entities/folder_item.dart';
import '../../domain/repositories/i_file_repository.dart';
import '../../domain/usecases/delete_file_usecase.dart';
import '../../domain/usecases/get_files_usecase.dart';
import '../../domain/usecases/rename_file_usecase.dart';

// EVENTS
abstract class FileEvent extends Equatable {
  const FileEvent();
  @override
  List<Object?> get props => [];
}

class LoadFilesEvent extends FileEvent {
  final String? folder;
  final int page;
  const LoadFilesEvent({this.folder, this.page = 1});
  @override
  List<Object?> get props => [folder, page];
}

class RenameFileEvent extends FileEvent {
  final String id;
  final String newName;
  const RenameFileEvent({required this.id, required this.newName});
  @override
  List<Object?> get props => [id, newName];
}

class DeleteFileEvent extends FileEvent {
  final String id;
  const DeleteFileEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class RestoreFileEvent extends FileEvent {
  final String id;
  const RestoreFileEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// STATES
abstract class FileState extends Equatable {
  const FileState();
  @override
  List<Object?> get props => [];
}

class FileInitialState extends FileState {
  const FileInitialState();
}

class FileLoadingState extends FileState {
  const FileLoadingState();
}

class FileFailureState extends FileState {
  final String message;
  const FileFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class FileLoadedState extends FileState {
  final List<FileItem> files;
  final List<FolderItem> folders;
  final String? currentFolder;

  const FileLoadedState({
    required this.files,
    required this.folders,
    this.currentFolder,
  });

  FileLoadedState copyWith({
    List<FileItem>? files,
    List<FolderItem>? folders,
    String? currentFolder,
  }) {
    return FileLoadedState(
      files: files ?? this.files,
      folders: folders ?? this.folders,
      currentFolder: currentFolder ?? this.currentFolder,
    );
  }

  @override
  List<Object?> get props => [files, folders, currentFolder];
}

// BLOC
class FileBloc extends Bloc<FileEvent, FileState> {
  final GetFilesUseCase getFilesUseCase;
  final RenameFileUseCase renameFileUseCase;
  final DeleteFileUseCase deleteFileUseCase;
  final IFileRepository repository;

  FileBloc({
    required this.getFilesUseCase,
    required this.renameFileUseCase,
    required this.deleteFileUseCase,
    required this.repository,
  }) : super(const FileInitialState()) {
    on<LoadFilesEvent>(_onLoadFiles);
    on<RenameFileEvent>(_onRenameFile);
    on<DeleteFileEvent>(_onDeleteFile);
    on<RestoreFileEvent>(_onRestoreFile);
  }

  Future<void> _onLoadFiles(LoadFilesEvent event, Emitter<FileState> emit) async {
    emit(const FileLoadingState());
    final filesRes = await getFilesUseCase(GetFilesParams(folder: event.folder, page: event.page));
    final foldersRes = await repository.getFolders();

    filesRes.fold(
      (Failure f) => emit(FileFailureState(f.message)),
      (files) {
        final folders = foldersRes.getOrElse((_) => []);
        emit(FileLoadedState(files: files, folders: folders, currentFolder: event.folder));
      },
    );
  }

  Future<void> _onRenameFile(RenameFileEvent event, Emitter<FileState> emit) async {
    if (state is FileLoadedState) {
      final current = state as FileLoadedState;
      final res = await renameFileUseCase(RenameFileParams(fileId: event.id, newName: event.newName));
      res.fold(
        (Failure f) => emit(FileFailureState(f.message)),
        (renamed) {
          final updated = current.files.map((f) => f.id == event.id ? renamed : f).toList();
          emit(current.copyWith(files: updated));
        },
      );
    }
  }

  Future<void> _onDeleteFile(DeleteFileEvent event, Emitter<FileState> emit) async {
    if (state is FileLoadedState) {
      final current = state as FileLoadedState;
      await deleteFileUseCase(event.id);
      final updated = current.files.where((f) => f.id != event.id).toList();
      emit(current.copyWith(files: updated));
    }
  }

  Future<void> _onRestoreFile(RestoreFileEvent event, Emitter<FileState> emit) async {
    await repository.restoreFile(event.id);
    add(const LoadFilesEvent());
  }
}
