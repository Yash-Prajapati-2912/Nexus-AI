import 'package:flutter/material.dart';

class VersionCard extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const VersionCard({
    super.key,
    required this.appVersion,
    required this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.auto_awesome, size: 40, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 12),
        Text(
          'Nexus AI',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Enterprise Student Life OS',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text('v$appVersion ($buildNumber)'),
          backgroundColor: theme.colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: theme.colorScheme.onSecondaryContainer),
        ),
      ],
    );
  }
}
