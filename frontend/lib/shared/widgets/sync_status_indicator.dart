import 'package:flutter/material.dart';
import '../../core/offline/sync_manager.dart';

class SyncStatusIndicator extends StatelessWidget {
  final SyncStatus status;

  const SyncStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (status.state == SyncState.idle && status.pendingItemsCount == 0) {
      return const SizedBox.shrink();
    }

    Color bgColor = Colors.orange;
    String label = 'Offline Mode (${status.pendingItemsCount} pending changes)';
    IconData icon = Icons.cloud_off;

    if (status.state == SyncState.syncing) {
      bgColor = theme.colorScheme.primary;
      label = 'Syncing data with cloud...';
      icon = Icons.sync;
    } else if (status.state == SyncState.success) {
      bgColor = Colors.green;
      label = 'All changes synchronized';
      icon = Icons.cloud_done;
    } else if (status.state == SyncState.error) {
      bgColor = Colors.red;
      label = 'Sync error: ${status.lastError ?? "Retry scheduled"}';
      icon = Icons.sync_problem;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
