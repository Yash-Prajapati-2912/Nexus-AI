import 'package:equatable/equatable.dart';

class BackupEntity extends Equatable {
  final bool autoBackupEnabled;
  final bool cloudSyncEnabled;
  final String backupFrequency;
  final DateTime? lastBackupTime;
  final String lastBackupSize;
  final String status;

  const BackupEntity({
    required this.autoBackupEnabled,
    required this.cloudSyncEnabled,
    required this.backupFrequency,
    this.lastBackupTime,
    required this.lastBackupSize,
    required this.status,
  });

  factory BackupEntity.initial() {
    return BackupEntity(
      autoBackupEnabled: true,
      cloudSyncEnabled: true,
      backupFrequency: 'Daily',
      lastBackupTime: DateTime.now().subtract(const Duration(hours: 12)),
      lastBackupSize: '12.4 MB',
      status: 'IDLE',
    );
  }

  BackupEntity copyWith({
    bool? autoBackupEnabled,
    bool? cloudSyncEnabled,
    String? backupFrequency,
    DateTime? lastBackupTime,
    String? lastBackupSize,
    String? status,
  }) {
    return BackupEntity(
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      lastBackupSize: lastBackupSize ?? this.lastBackupSize,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        autoBackupEnabled,
        cloudSyncEnabled,
        backupFrequency,
        lastBackupTime,
        lastBackupSize,
        status,
      ];
}
