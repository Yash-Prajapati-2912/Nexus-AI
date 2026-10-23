import 'package:flutter/material.dart';
import '../../domain/entities/budget_recommendation.dart';

class BudgetRecommendationCard extends StatelessWidget {
  final BudgetRecommendation recommendation;

  const BudgetRecommendationCard({super.key, required this.recommendation});

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
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.blueAccent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Safe Daily Limit',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '₹${recommendation.safeDailySpendingLimit.toStringAsFixed(2)}/day',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(recommendation.optimizationStrategy, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
