import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/download_task.dart';
import '../../domain/usecases/download_file_usecase.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
  @override
  List<Object?> get props => [];
}

class StartDownloadEvent extends DownloadEvent {
  final String fileId;
  final String fileName;
  const StartDownloadEvent({required this.fileId, required this.fileName});
  @override
  List<Object?> get props => [fileId, fileName];
}

abstract class DownloadState extends Equatable {
  const DownloadState();
  @override
  List<Object?> get props => [];
}

class DownloadInitialState extends DownloadState {
  const DownloadInitialState();
}

class DownloadingState extends DownloadState {
  final DownloadTask task;
  const DownloadingState(this.task);
  @override
  List<Object?> get props => [task];
}

class DownloadSuccessState extends DownloadState {
  final String signedUrl;
  const DownloadSuccessState(this.signedUrl);
  @override
  List<Object?> get props => [signedUrl];
}

class DownloadFailureState extends DownloadState {
  final String message;
  const DownloadFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadFileUseCase downloadFileUseCase;

  DownloadBloc({required this.downloadFileUseCase}) : super(const DownloadInitialState()) {
    on<StartDownloadEvent>((event, emit) async {
      emit(DownloadingState(DownloadTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileId: event.fileId,
        fileName: event.fileName,
        progress: 0.5,
        status: DownloadStatus.DOWNLOADING,
      )));

      final res = await downloadFileUseCase(event.fileId);

      res.fold(
        (Failure f) => emit(DownloadFailureState(f.message)),
        (url) => emit(DownloadSuccessState(url)),
      );
    });
  }
}
