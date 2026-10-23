import 'package:flutter/material.dart';

class SavedMessagesPage extends StatelessWidget {
  const SavedMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved & Bookmarked Messages')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Icon(Icons.bookmark_border_rounded, size: 36, color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 16),
              Text(
                'No Saved Messages Yet',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Important AI Mentor advice and explanations you bookmark will appear here.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
