import 'package:flutter/material.dart';
import '../../domain/entities/notification_item.dart';
import 'priority_badge.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Card(
        elevation: item.isRead ? 1 : 3,
        color: item.isRead ? null : theme.colorScheme.primaryContainer.withAlpha(20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(12),
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundColor: _getModuleColor(item.module).withAlpha(30),
                child: Icon(_getModuleIcon(item.module), color: _getModuleColor(item.module), size: 22),
              ),
              if (!item.isRead)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PriorityBadge(priority: item.priority),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(item.body, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(
                '${item.module} • ${_timeAgo(item.createdAt)}',
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getModuleColor(String module) {
    switch (module.toUpperCase()) {
      case 'PLANNER':
        return Colors.blueAccent;
      case 'FINANCE':
        return const Color(0xFF10B981);
      case 'MENTOR':
        return const Color(0xFF6366F1);
      case 'SECURITY':
        return Colors.redAccent;
      default:
        return Colors.purpleAccent;
    }
  }

  IconData _getModuleIcon(String module) {
    switch (module.toUpperCase()) {
      case 'PLANNER':
        return Icons.calendar_today_rounded;
      case 'FINANCE':
        return Icons.account_balance_wallet_rounded;
      case 'MENTOR':
        return Icons.auto_awesome;
      case 'SECURITY':
        return Icons.security_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
