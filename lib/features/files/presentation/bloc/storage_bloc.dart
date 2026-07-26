import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/storage_usage.dart';
import '../../domain/repositories/i_file_repository.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();
  @override
  List<Object?> get props => [];
}

class LoadStorageUsageEvent extends StorageEvent {
  const LoadStorageUsageEvent();
}

abstract class StorageState extends Equatable {
  const StorageState();
  @override
  List<Object?> get props => [];
}

class StorageInitialState extends StorageState {
  const StorageInitialState();
}

class StorageLoadingState extends StorageState {
  const StorageLoadingState();
}

class StorageLoadedState extends StorageState {
  final StorageUsage usage;
  const StorageLoadedState(this.usage);
  @override
  List<Object?> get props => [usage];
}

class StorageFailureState extends StorageState {
  final String message;
  const StorageFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final IFileRepository repository;

  StorageBloc({required this.repository}) : super(const StorageInitialState()) {
    on<LoadStorageUsageEvent>((event, emit) async {
      emit(const StorageLoadingState());
      final res = await repository.getStorageUsage();
      res.fold(
        (Failure f) => emit(StorageFailureState(f.message)),
        (usage) => emit(StorageLoadedState(usage)),
      );
    });
  }
}
