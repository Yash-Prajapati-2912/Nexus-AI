import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/backup_bloc.dart';
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
              Card(
                color: Colors.amber.withValues(alpha: 0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.amber.shade700.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade800),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Cloud Backup & Automated Restore is currently unavailable. Server-side backup storage infrastructure is not configured.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BackupCard(
                lastBackupDate: lastDateStr,
                backupSize: sizeStr,
                status: 'UNAVAILABLE',
                onBackupNow: null,
              ),
              const SizedBox(height: 16),
              const PreferenceCard(
                title: 'Automatic Sync & Cloud Rules',
                subtitle: 'Configure automated background backups',
                child: Column(
                  children: [
                    SwitchTile(
                      icon: Icons.sync,
                      title: 'Automatic Daily Backup',
                      subtitle: 'Automated daily backup schedule is not available yet',
                      value: false,
                      onChanged: null,
                    ),
                    SwitchTile(
                      icon: Icons.cloud_done_outlined,
                      title: 'Encrypted Cloud Storage',
                      subtitle: 'Cloud storage synchronization is not available yet',
                      value: false,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              PreferenceCard(
                title: 'Restore Points',
                subtitle: 'Restore previous system snapshot',
                child: ListTile(
                  leading: const Icon(Icons.history_outlined, color: Colors.grey),
                  title: const Text('Restore Latest Backup'),
                  subtitle: Text('No snapshots available for restore (Last: $lastDateStr)'),
                  trailing: const ElevatedButton(
                    onPressed: null,
                    child: Text('Restore'),
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
