import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class KeyMetricsOverviewWidget extends StatelessWidget {
  final int activeTasksCount;
  final int urgentTasksCount;
  final int completedTasksCount;
  final int totalTasksCount;
  final double spentThisMonth;
  final double remainingBudget;

  const KeyMetricsOverviewWidget({
    super.key,
    required this.activeTasksCount,
    required this.urgentTasksCount,
    required this.completedTasksCount,
    required this.totalTasksCount,
    required this.spentThisMonth,
    required this.remainingBudget,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = totalTasksCount > 0
        ? ((completedTasksCount / totalTasksCount) * 100).round()
        : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 900;
        final isTablet = width >= 600 && width < 900;

        final cards = [
          _buildMetricCard(
            context,
            title: 'Active Tasks',
            value: '$activeTasksCount',
            subtitle: 'Pending & In-Progress',
            icon: Icons.assignment_rounded,
            iconColor: DesignColors.primaryDark,
            badge: '$activeTasksCount active',
            badgeColor: DesignColors.primaryDark,
          ),
          _buildMetricCard(
            context,
            title: 'Due Soon / Urgent',
            value: '$urgentTasksCount',
            subtitle: urgentTasksCount > 0 ? 'Requires attention' : 'No urgent tasks',
            icon: Icons.error_outline_rounded,
            iconColor: DesignColors.errorDark,
            badge: urgentTasksCount > 0 ? 'High Priority' : 'Clear',
            badgeColor: urgentTasksCount > 0 ? DesignColors.errorDark : DesignColors.positiveGreenDark,
          ),
          _buildMetricCard(
            context,
            title: 'Completed',
            value: '$completedTasksCount',
            subtitle: '$completionRate% completion rate',
            icon: Icons.task_alt_rounded,
            iconColor: DesignColors.positiveGreenDark,
            badge: '$completionRate%',
            badgeColor: DesignColors.positiveGreenDark,
          ),
          _buildMetricCard(
            context,
            title: 'Monthly Spent',
            value: '₹${spentThisMonth.toStringAsFixed(0)}',
            subtitle: remainingBudget >= 0
                ? '₹${remainingBudget.toStringAsFixed(0)} remaining'
                : 'Budget exceeded',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: DesignColors.secondaryDark,
            badge: remainingBudget >= 0 ? 'On Track' : 'Over Budget',
            badgeColor: remainingBudget >= 0 ? DesignColors.secondaryDark : DesignColors.errorDark,
          ),
        ];

        if (isDesktop) {
          return Row(
            children: cards
                .map((card) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: card,
                      ),
                    ))
                .toList()
              ..last = Expanded(child: cards.last),
          );
        } else if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 12),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: cards
                .map((card) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: card,
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String badge,
    required Color badgeColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                fontFamily: 'Poppins',
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              fontFamily: 'Poppins',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
