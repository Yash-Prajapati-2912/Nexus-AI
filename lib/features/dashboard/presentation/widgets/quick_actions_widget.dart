import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.add_task_rounded, 'label': 'Add Task', 'route': RouteNames.planner},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Finance', 'route': RouteNames.finance},
      {'icon': Icons.psychology_rounded, 'label': 'Ask AI', 'route': RouteNames.aiMentor},
      {'icon': Icons.calendar_month_rounded, 'label': 'Calendar', 'route': RouteNames.planner},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AppCard(
                  onTap: () => context.push(item['route'] as String),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(item['icon'] as IconData, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(item['label'] as String, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
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
