import 'package:flutter/material.dart';
import '../../domain/entities/upload_task.dart';

class UploadProgressCard extends StatelessWidget {
  final UploadTask task;

  const UploadProgressCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (task.progress * 100).toInt();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.cloud_upload_rounded, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: task.progress, minHeight: 4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('$pct%', style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
