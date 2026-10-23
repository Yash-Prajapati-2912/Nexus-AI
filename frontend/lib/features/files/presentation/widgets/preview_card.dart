import 'package:flutter/material.dart';
import '../../domain/entities/file_item.dart';

class PreviewCard extends StatelessWidget {
  final FileItem file;

  const PreviewCard({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.insert_drive_file_rounded, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(file.fileName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('${file.extension.toUpperCase()} • ${(file.sizeBytes / 1024).toStringAsFixed(1)} KB'),
          ],
        ),
      ),
    );
  }
}
