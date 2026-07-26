import 'package:flutter/material.dart';

class MarkdownViewer extends StatelessWidget {
  final String content;

  const MarkdownViewer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = content.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(line.substring(2), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(line.substring(3), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          );
        } else if (line.startsWith('- ') || line.startsWith('* ')) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                Expanded(child: Text(line.substring(2), style: theme.textTheme.bodyMedium)),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(line, style: theme.textTheme.bodyMedium),
          );
        }
      }).toList(),
    );
  }
}
