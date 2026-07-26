import 'package:flutter/material.dart';

class EmptyNotificationWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyNotificationWidget({
    super.key,
    this.title = 'No Notifications Yet',
    this.subtitle = "You're all caught up! Check back later for study alerts and financial insights.",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.notifications_off_rounded, size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
