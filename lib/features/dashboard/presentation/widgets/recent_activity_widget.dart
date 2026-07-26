import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/lists/notification_list_tile.dart';
import '../../domain/entities/notification_summary_entity.dart';

class RecentActivityWidget extends StatelessWidget {
  final NotificationSummaryEntity notificationSummary;

  const RecentActivityWidget({super.key, required this.notificationSummary});

  @override
  Widget build(BuildContext context) {
    if (notificationSummary.recentNotifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final first = notificationSummary.recentNotifications.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Notifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        NotificationListTile(
          title: first.title,
          body: first.body,
          time: '${first.createdAt.hour}:${first.createdAt.minute.toString().padLeft(2, '0')}',
          isRead: false,
          onTap: () {},
        ),
      ],
    );
  }
}
