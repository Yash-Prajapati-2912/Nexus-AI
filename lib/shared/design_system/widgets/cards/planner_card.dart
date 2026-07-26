import 'package:flutter/material.dart';
import 'app_card.dart';

class PlannerCard extends StatelessWidget {
  final String title;
  final String dueTime;
  final bool isCompleted;
  final ValueChanged<bool?> onToggle;

  const PlannerCard({
    super.key,
    required this.title,
    required this.dueTime,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Checkbox(value: isCompleted, onChanged: onToggle),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                ),
                Text(dueTime, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
