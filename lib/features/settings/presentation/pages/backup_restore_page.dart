import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/backup_bloc.dart';
import '../bloc/backup_event.dart';
import '../bloc/backup_state.dart';
import '../widgets/preference_card.dart';
import '../widgets/backup_card.dart';
import '../widgets/switch_tile.dart';
import '../widgets/backup_loader.dart';

class BackupRestorePage extends StatelessWidget {
  const BackupRestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state is BackupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is BackupFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is BackupInProgress) {
            return Center(child: BackupLoader(status: state.status));
          }

          final backup = (state is BackupSuccess) ? state.backup : null;
          final lastDateStr = backup?.lastBackupTime != null
              ? '${backup!.lastBackupTime!.day}/${backup.lastBackupTime!.month}/${backup.lastBackupTime!.year}'
              : 'Never';
          final sizeStr = backup?.lastBackupSize ?? '0 MB';

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              BackupCard(
                lastBackupDate: lastDateStr,
                backupSize: sizeStr,
                status: backup?.status ?? 'IDLE',
                onBackupNow: () {
                  context.read<BackupBloc>().add(StartManualBackupEvent());
                },
              ),
              const SizedBox(height: 16),
              PreferenceCard(
                title: 'Automatic Sync & Cloud Rules',
                subtitle: 'Configure automated background backups',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.sync,
                      title: 'Automatic Daily Backup',
                      subtitle: 'Backup user data every 24 hours automatically',
                      value: backup?.autoBackupEnabled ?? true,
                      onChanged: (val) {
                        context.read<BackupBloc>().add(ToggleAutoBackupEvent(val));
                      },
                    ),
                    SwitchTile(
                      icon: Icons.cloud_done_outlined,
                      title: 'Encrypted Cloud Storage',
                      subtitle: 'AES-256 encrypted sync to secure cloud servers',
                      value: backup?.cloudSyncEnabled ?? true,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Restore Points',
                subtitle: 'Restore previous system snapshot',
                child: ListTile(
                  leading: const Icon(Icons.history_outlined, color: Colors.blue),
                  title: const Text('Restore Latest Backup'),
                  subtitle: Text('Snapshot from $lastDateStr ($sizeStr)'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<BackupBloc>().add(const RestoreBackupEvent('latest-backup-123'));
                    },
                    child: const Text('Restore'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
