import 'package:flutter/material.dart';
import '../../domain/entities/savings_recommendation.dart';

class SavingsCard extends StatelessWidget {
  final SavingsRecommendation savings;

  const SavingsCard({super.key, required this.savings});

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
                Row(
                  children: [
                    const Icon(Icons.savings_rounded, color: Color(0xFF10B981), size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Savings Advisor',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '+\$${savings.totalPotentialMonthlySavings.toStringAsFixed(0)}/mo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(savings.aiStrategySummary, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
