import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';

class BudgetProgressWidget extends StatelessWidget {
  final Budget budget;

  const BudgetProgressWidget({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usedPct = budget.usedPercentage;
    final visualValue = budget.visualProgress;
    final isOver = budget.isOverBudget;

    Color progressColor;
    if (isOver) {
      progressColor = Colors.redAccent;
    } else if (usedPct >= 80.0) {
      progressColor = Colors.orangeAccent;
    } else {
      progressColor = theme.colorScheme.primary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spent: ₹${budget.currentSpent.toStringAsFixed(0)} / ₹${budget.totalLimit.toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${usedPct.toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: progressColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: visualValue,
            minHeight: 10,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}
