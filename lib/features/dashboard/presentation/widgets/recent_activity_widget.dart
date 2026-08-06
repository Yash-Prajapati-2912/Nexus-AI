import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/lists/notification_list_tile.dart';
import '../../domain/entities/notification_summary_entity.dart';

class RecentActivityWidget extends StatelessWidget {
  final NotificationSummaryEntity notificationSummary;

  const RecentActivityWidget({super.key, required this.notificationSummary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasNotifications = notificationSummary.recentNotifications.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Notifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        hasNotifications
            ? NotificationListTile(
                title: notificationSummary.recentNotifications.first.title,
                body: notificationSummary.recentNotifications.first.body,
                time: '${notificationSummary.recentNotifications.first.createdAt.hour}:${notificationSummary.recentNotifications.first.createdAt.minute.toString().padLeft(2, '0')}',
                isRead: false,
                onTap: () {},
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: isDark ? Colors.white54 : Colors.black45,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You're all caught up! No recent notifications.",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
