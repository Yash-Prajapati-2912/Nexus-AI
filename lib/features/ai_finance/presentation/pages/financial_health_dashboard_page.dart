import 'package:flutter/material.dart';
import '../../domain/entities/financial_health.dart';
import '../widgets/finance_ai_summary.dart';

class FinancialHealthDashboardPage extends StatelessWidget {
  final FinancialHealth? health;

  const FinancialHealthDashboardPage({super.key, this.health});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = health ??
        const FinancialHealth(
          overallScore: 84,
          budgetHealthScore: 80,
          savingsScore: 88,
          expenseScore: 82,
          incomeStabilityScore: 90,
          cashFlowHealthScore: 85,
          investmentReadinessScore: 75,
          wellnessRating: 'EXCELLENT',
          summaryReasoning: 'Your financial wellness is high. You maintain positive cash flow and disciplined savings habits.',
          topStrengths: ['Consistent stipend income', 'Strong emergency savings allocation'],
          keyRisks: ['Occasional dining out spikes'],
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Health Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FinanceAISummary(health: data),
            const SizedBox(height: 20),
            Text('Health Score Breakdown', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ScoreTile(label: 'Budget Health', score: data.budgetHealthScore),
            _ScoreTile(label: 'Savings Score', score: data.savingsScore),
            _ScoreTile(label: 'Expense Efficiency', score: data.expenseScore),
            _ScoreTile(label: 'Income Stability', score: data.incomeStabilityScore),
            _ScoreTile(label: 'Cash Flow Health', score: data.cashFlowHealthScore),
            _ScoreTile(label: 'Investment Readiness', score: data.investmentReadinessScore),
            const SizedBox(height: 24),
            Text('Top Financial Strengths', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...data.topStrengths.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreTile({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text('$score/100', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 100.0,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }
}
