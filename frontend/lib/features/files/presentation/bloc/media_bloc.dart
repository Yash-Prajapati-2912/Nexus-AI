import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/file_item.dart';
import '../../domain/usecases/get_files_usecase.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();
  @override
  List<Object?> get props => [];
}

class LoadMediaGalleryEvent extends MediaEvent {
  final String mediaType; // IMAGES, VIDEOS, AUDIO, ALL
  const LoadMediaGalleryEvent({this.mediaType = 'ALL'});
  @override
  List<Object?> get props => [mediaType];
}

abstract class MediaState extends Equatable {
  const MediaState();
  @override
  List<Object?> get props => [];
}

class MediaInitialState extends MediaState {
  const MediaInitialState();
}

class MediaLoadingState extends MediaState {
  const MediaLoadingState();
}

class MediaLoadedState extends MediaState {
  final List<FileItem> mediaFiles;
  final String selectedType;

  const MediaLoadedState({required this.mediaFiles, required this.selectedType});

  @override
  List<Object?> get props => [mediaFiles, selectedType];
}

class MediaFailureState extends MediaState {
  final String message;
  const MediaFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetFilesUseCase getFilesUseCase;

  MediaBloc({required this.getFilesUseCase}) : super(const MediaInitialState()) {
    on<LoadMediaGalleryEvent>((event, emit) async {
      emit(const MediaLoadingState());
      final res = await getFilesUseCase(const GetFilesParams(limit: 100));
      res.fold(
        (Failure f) => emit(MediaFailureState(f.message)),
        (files) {
          final filtered = files.where((f) {
            if (event.mediaType == 'IMAGES') return ['png', 'jpg', 'jpeg', 'webp'].contains(f.extension.toLowerCase());
            if (event.mediaType == 'VIDEOS') return ['mp4', 'mkv', 'mov', 'avi'].contains(f.extension.toLowerCase());
            if (event.mediaType == 'AUDIO') return ['mp3', 'wav', 'aac', 'm4a'].contains(f.extension.toLowerCase());
            return true;
          }).toList();
          emit(MediaLoadedState(mediaFiles: filtered, selectedType: event.mediaType));
        },
      );
    });
  }
}
