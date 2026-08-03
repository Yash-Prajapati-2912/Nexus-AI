import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final labelColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    final actions = [
      {'icon': Icons.add_task_rounded, 'label': 'Add Task', 'route': RouteNames.planner},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Finance', 'route': RouteNames.finance},
      {'icon': Icons.psychology_rounded, 'label': 'Ask AI', 'route': RouteNames.aiMentor},
      {'icon': Icons.calendar_month_rounded, 'label': 'Calendar', 'route': RouteNames.planner},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GlassCard(
                  onTap: () => context.push(item['route'] as String),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

