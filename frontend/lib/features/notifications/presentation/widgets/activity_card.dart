import 'package:flutter/material.dart';
import '../../domain/entities/activity_item.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(Icons.history_rounded, size: 18, color: theme.colorScheme.primary),
      ),
      title: Text(activity.description, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(activity.module, style: theme.textTheme.labelSmall),
      trailing: Text(
        '${activity.timestamp.hour}:${activity.timestamp.minute.toString().padLeft(2, "0")}',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
