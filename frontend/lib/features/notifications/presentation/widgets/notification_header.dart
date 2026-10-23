import 'package:flutter/material.dart';
import 'unread_badge.dart';

class NotificationHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Notifications', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              UnreadBadge(count: unreadCount),
            ],
          ),
          if (unreadCount > 0)
            TextButton.icon(
              icon: const Icon(Icons.done_all_rounded, size: 16),
              label: const Text('Mark all as read'),
              onPressed: onMarkAllRead,
            ),
        ],
      ),
    );
  }
}
