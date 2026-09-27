import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/upload_task.dart';
import '../../domain/usecases/upload_file_usecase.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
  @override
  List<Object?> get props => [];
}

class StartUploadEvent extends UploadEvent {
  final String filePath;
  final String folder;
  final String moduleName;

  const StartUploadEvent({
    required this.filePath,
    required this.folder,
    required this.moduleName,
  });

  @override
  List<Object?> get props => [filePath, folder, moduleName];
}

abstract class UploadState extends Equatable {
  const UploadState();
  @override
  List<Object?> get props => [];
}

class UploadInitialState extends UploadState {
  const UploadInitialState();
}

class UploadingState extends UploadState {
  final UploadTask task;
  const UploadingState(this.task);
  @override
  List<Object?> get props => [task];
}

class UploadSuccessState extends UploadState {
  final String fileId;
  const UploadSuccessState(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class UploadFailureState extends UploadState {
  final String message;
  const UploadFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadFileUseCase uploadFileUseCase;

  UploadBloc({required this.uploadFileUseCase}) : super(const UploadInitialState()) {
    on<StartUploadEvent>((event, emit) async {
      emit(UploadingState(UploadTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: event.filePath,
        fileName: event.filePath.split('/').last,
        progress: 0.5,
        status: UploadStatus.uploading,
      )));

      final res = await uploadFileUseCase(UploadFileParams(
        filePath: event.filePath,
        folder: event.folder,
        moduleName: event.moduleName,
      ));

      res.fold(
        (Failure f) => emit(UploadFailureState(f.message)),
        (file) => emit(UploadSuccessState(file.id)),
      );
    });
  }
}
