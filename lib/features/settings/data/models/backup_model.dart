import '../../domain/entities/backup_entity.dart';

class BackupModel extends BackupEntity {
  const BackupModel({
    required super.autoBackupEnabled,
    required super.cloudSyncEnabled,
    required super.backupFrequency,
    super.lastBackupTime,
    required super.lastBackupSize,
    required super.status,
  });

  factory BackupModel.initial() {
    return BackupModel.fromEntity(BackupEntity.initial());
  }

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      autoBackupEnabled: json['autoBackupEnabled'] as bool? ?? true,
      cloudSyncEnabled: json['cloudSyncEnabled'] as bool? ?? true,
      backupFrequency: json['backupFrequency'] as String? ?? 'Daily',
      lastBackupTime: json['lastBackupTime'] != null
          ? DateTime.tryParse(json['lastBackupTime'] as String)
          : null,
      lastBackupSize: json['lastBackupSize'] as String? ?? '0 MB',
      status: json['status'] as String? ?? 'IDLE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoBackupEnabled': autoBackupEnabled,
      'cloudSyncEnabled': cloudSyncEnabled,
      'backupFrequency': backupFrequency,
      'lastBackupTime': lastBackupTime?.toIso8601String(),
      'lastBackupSize': lastBackupSize,
      'status': status,
    };
  }

  factory BackupModel.fromEntity(BackupEntity entity) {
    return BackupModel(
      autoBackupEnabled: entity.autoBackupEnabled,
      cloudSyncEnabled: entity.cloudSyncEnabled,
      backupFrequency: entity.backupFrequency,
      lastBackupTime: entity.lastBackupTime,
      lastBackupSize: entity.lastBackupSize,
      status: entity.status,
    );
  }
}
