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
        final trimmed = line.trim();
        if (trimmed.isEmpty) {
          return const SizedBox(height: 4);
        } else if (trimmed.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(trimmed.substring(2), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          );
        } else if (trimmed.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(trimmed.substring(3), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          );
        } else if (trimmed.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(trimmed.substring(4), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          );
        } else if (trimmed.startsWith('- ') || trimmed.startsWith('* ') || trimmed.startsWith('• ')) {
          final bulletText = trimmed.startsWith('• ') ? trimmed.substring(2) : trimmed.substring(2);
          return Padding(
            padding: const EdgeInsets.only(left: 8, top: 3, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 16)),
                Expanded(child: _buildRichText(bulletText, theme.textTheme.bodyMedium)),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _buildRichText(trimmed, theme.textTheme.bodyMedium),
          );
        }
      }).toList(),
    );
  }

  Widget _buildRichText(String text, TextStyle? baseStyle) {
    if (!text.contains('**')) {
      return Text(text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      final isBold = i % 2 == 1;
      spans.add(TextSpan(
        text: parts[i],
        style: isBold ? baseStyle?.copyWith(fontWeight: FontWeight.bold) : baseStyle,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
