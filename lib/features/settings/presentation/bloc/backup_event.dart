import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

class StartManualBackupEvent extends BackupEvent {}

class RestoreBackupEvent extends BackupEvent {
  final String backupId;
  const RestoreBackupEvent(this.backupId);

  @override
  List<Object?> get props => [backupId];
}

class ToggleAutoBackupEvent extends BackupEvent {
  final bool enable;
  const ToggleAutoBackupEvent(this.enable);

  @override
  List<Object?> get props => [enable];
}
