import 'package:flutter/material.dart';
import '../../domain/entities/savings_recommendation.dart';

class SavingsAdvisorPage extends StatelessWidget {
  final SavingsRecommendation? savings;

  const SavingsAdvisorPage({super.key, this.savings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = savings ??
        const SavingsRecommendation(
          totalPotentialMonthlySavings: 160.00,
          tips: [
            SavingsTip(title: 'Switch to Meal Prep', category: 'Food & Dining', potentialMonthlySavings: 80, difficultyLevel: 'EASY', actionableAdvice: 'Prep lunches on Sunday evenings.'),
            SavingsTip(title: 'Cancel Unused Streaming', category: 'Subscriptions', potentialMonthlySavings: 15, difficultyLevel: 'EASY', actionableAdvice: 'Cancel redundant streaming tier.'),
          ],
          aiStrategySummary: 'Implement these 2 micro-habits to unlock ₹1,600/month in extra savings.',
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Advisor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF10B981).withAlpha(30),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.savings_rounded, color: Color(0xFF10B981), size: 36),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Potential Savings', style: theme.textTheme.labelMedium),
                        Text('+₹${data.totalPotentialMonthlySavings.toStringAsFixed(0)}/month', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Actionable Savings Tips', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...data.tips.map((tip) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${tip.actionableAdvice}\nDifficulty: ${tip.difficultyLevel}'),
                    trailing: Text('+₹${tip.potentialMonthlySavings.toStringAsFixed(0)}/mo', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
