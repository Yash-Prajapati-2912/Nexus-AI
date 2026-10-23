import 'package:flutter/material.dart';
import '../../domain/entities/goal_analysis.dart';
import 'risk_indicator.dart';

class GoalProgressCard extends StatelessWidget {
  final GoalAnalysis goal;

  const GoalProgressCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.goalTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                RiskIndicator(riskLevel: goal.riskLevel),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: goal.currentProgressPercentage / 100.0,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              goal.aiOptimizationTip,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
