import 'package:flutter/material.dart';
import '../../domain/entities/notification_item.dart';

class NotificationDetailsPage extends StatelessWidget {
  final NotificationItem? item;

  const NotificationDetailsPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notification = item ?? NotificationItem(
      id: 'd1',
      userId: 'u1',
      title: 'CS101 Assignment Due Today',
      body: 'Your Data Structures & Algorithms assignment is due by 11:59 PM PST. Please submit on portal.',
      type: 'PLANNER',
      module: 'PLANNER',
      category: 'ASSIGNMENT',
      priority: 'HIGH',
      createdAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Module: ${notification.module} • Priority: ${notification.priority}', style: theme.textTheme.labelMedium),
            const SizedBox(height: 16),
            Text(notification.body, style: theme.textTheme.bodyMedium),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Open Related Module'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
