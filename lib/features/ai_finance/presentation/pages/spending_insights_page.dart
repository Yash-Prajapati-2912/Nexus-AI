import 'package:flutter/material.dart';
import '../../domain/entities/spending_insight.dart';
import '../widgets/ai_insight_card.dart';

class SpendingInsightsPage extends StatelessWidget {
  final SpendingInsight? insight;

  const SpendingInsightsPage({super.key, this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = insight ??
        const SpendingInsight(
          dailyAverageSpent: 28.50,
          monthlyComparisonPercentage: -12.4,
          weeklyComparisonPercentage: -4.2,
          highestCategories: [
            CategorySpendingShare(categoryName: 'Education', amount: 500, percentage: 35, trendDirection: 'STABLE'),
            CategorySpendingShare(categoryName: 'Food & Dining', amount: 420, percentage: 30, trendDirection: 'DECREASING'),
            CategorySpendingShare(categoryName: 'Transportation', amount: 250, percentage: 18, trendDirection: 'STABLE'),
          ],
          lifestyleAnalysis: 'Your lifestyle spending is well aligned with average university student benchmarks.',
          detectedAnomalies: ['Unusual ₹1,450 textbook purchase on Monday'],
          confidenceScore: 0.94,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('AI Spending Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIInsightCard(insight: data),
            const SizedBox(height: 20),
            Text('Highest Spending Categories', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...data.highestCategories.map((cat) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(cat.categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Trend: ${cat.trendDirection}'),
                    trailing: Text('₹${cat.amount.toStringAsFixed(0)} (${cat.percentage.toInt()}%)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
