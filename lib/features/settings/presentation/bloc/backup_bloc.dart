import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/backup_entity.dart';
import '../../domain/usecases/backup_data_usecase.dart';
import '../../domain/usecases/restore_data_usecase.dart';
import 'backup_event.dart';
import 'backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupDataUseCase backupDataUseCase;
  final RestoreDataUseCase restoreDataUseCase;

  BackupBloc({
    required this.backupDataUseCase,
    required this.restoreDataUseCase,
  }) : super(BackupSuccess(BackupEntity.initial(), 'Ready'));

  Future<void> _onStartManualBackup(StartManualBackupEvent event, Emitter<BackupState> emit) async {
    emit(const BackupInProgress('Creating Cloud Backup...'));
    final res = await backupDataUseCase(const NoParams());
    res.fold(
      (failure) => emit(BackupFailureState(failure.message)),
      (backup) => emit(BackupSuccess(backup, 'Backup created successfully')),
    );
  }

  Future<void> _onRestoreBackup(RestoreBackupEvent event, Emitter<BackupState> emit) async {
    emit(const BackupInProgress('Restoring data from cloud backup...'));
    final res = await restoreDataUseCase(event.backupId);
    res.fold(
      (failure) => emit(BackupFailureState(failure.message)),
      (backup) => emit(BackupSuccess(backup, 'Backup restored successfully')),
    );
  }

  Future<void> _onToggleAutoBackup(ToggleAutoBackupEvent event, Emitter<BackupState> emit) async {
    if (state is BackupSuccess) {
      final current = (state as BackupSuccess).backup;
      final updated = current.copyWith(autoBackupEnabled: event.enable);
      emit(BackupSuccess(updated, 'Auto-backup setting saved'));
    }
  }

  BackupBloc init() {
    on<StartManualBackupEvent>(_onStartManualBackup);
    on<RestoreBackupEvent>(_onRestoreBackup);
    on<ToggleAutoBackupEvent>(_onToggleAutoBackup);
    return this;
  }
}
