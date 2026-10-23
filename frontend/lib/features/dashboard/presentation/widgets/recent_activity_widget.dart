import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
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
        Row(
          children: [
            const Icon(
              Icons.notifications_active_rounded,
              size: 20,
              color: DesignColors.primaryDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Recent Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasNotifications)
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "You're all caught up! No recent unread notifications.",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: notificationSummary.recentNotifications.take(3).map((notif) {
                final timeStr =
                    '${notif.createdAt.hour}:${notif.createdAt.minute.toString().padLeft(2, '0')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: DesignColors.primaryDark.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_rounded,
                            size: 16, color: DesignColors.primaryDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              notif.body,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? DesignColors.textSecondaryDark
                                    : DesignColors.textSecondaryLight,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? DesignColors.textSecondaryDark
                              : DesignColors.textSecondaryLight,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
