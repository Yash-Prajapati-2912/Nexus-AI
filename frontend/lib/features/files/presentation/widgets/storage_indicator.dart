import 'package:flutter/material.dart';

class StorageIndicator extends StatelessWidget {
  final int usedBytes;
  final int totalBytes;

  const StorageIndicator({super.key, required this.usedBytes, required this.totalBytes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = (usedBytes / totalBytes.toDouble()).clamp(0.0, 1.0);
    final usedMB = (usedBytes / (1024 * 1024)).toStringAsFixed(1);
    final totalGB = (totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Storage Usage', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('$usedMB MB / $totalGB GB', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
