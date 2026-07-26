import 'package:flutter/material.dart';
import '../../domain/entities/budget_recommendation.dart';

class BudgetRecommendationsPage extends StatelessWidget {
  final BudgetRecommendation? recommendation;

  const BudgetRecommendationsPage({super.key, this.recommendation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = recommendation ??
        const BudgetRecommendation(
          safeDailySpendingLimit: 32.50,
          recommendedTotalMonthlyBudget: 950.00,
          categoryAdjustments: [
            CategoryBudgetAdjustment(categoryName: 'Food & Dining', currentLimit: 500, recommendedLimit: 450, reasoning: 'Average usage is \$420'),
            CategoryBudgetAdjustment(categoryName: 'Entertainment', currentLimit: 200, recommendedLimit: 150, reasoning: 'Save \$50 towards emergency fund'),
          ],
          optimizationStrategy: 'Optimizing monthly caps based on historical 3-month spending trends.',
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Recommendations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.colorScheme.primaryContainer.withAlpha(80),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Recommended Safe Daily Limit', style: theme.textTheme.labelMedium),
                    const SizedBox(height: 4),
                    Text('\$${data.safeDailySpendingLimit.toStringAsFixed(2)}/day', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Category Optimizations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...data.categoryAdjustments.map((adj) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(adj.categoryName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Current: \$${adj.currentLimit.toStringAsFixed(0)} ➔ Recommended: \$${adj.recommendedLimit.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        const SizedBox(height: 4),
                        Text(adj.reasoning, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
