import 'package:flutter/material.dart';
import '../../domain/entities/spending_insight.dart';
import 'confidence_badge.dart';

class AIInsightCard extends StatelessWidget {
  final SpendingInsight insight;
  final VoidCallback? onTap;

  const AIInsightCard({super.key, required this.insight, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                      const Icon(Icons.psychology_rounded, color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Spending Analysis',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ConfidenceBadge(confidenceScore: insight.confidenceScore),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                insight.lifestyleAnalysis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatPill(
                    label: 'Daily Avg',
                    value: '\$${insight.dailyAverageSpent.toStringAsFixed(2)}',
                  ),
                  const SizedBox(width: 8),
                  _StatPill(
                    label: 'Vs Last Month',
                    value: '${insight.monthlyComparisonPercentage}%',
                    isPositive: insight.monthlyComparisonPercentage < 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final bool isPositive;

  const _StatPill({required this.label, required this.value, this.isPositive = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final col = isPositive ? const Color(0xFF10B981) : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: theme.textTheme.labelSmall),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: col)),
        ],
      ),
    );
  }
}
