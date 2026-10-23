import 'package:equatable/equatable.dart';
import '../../domain/entities/backup_entity.dart';

abstract class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {}

class BackupInProgress extends BackupState {
  final String status;
  const BackupInProgress(this.status);

  @override
  List<Object?> get props => [status];
}

class BackupSuccess extends BackupState {
  final BackupEntity backup;
  final String message;

  const BackupSuccess(this.backup, this.message);

  @override
  List<Object?> get props => [backup, message];
}

class BackupFailureState extends BackupState {
  final String message;
  const BackupFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
