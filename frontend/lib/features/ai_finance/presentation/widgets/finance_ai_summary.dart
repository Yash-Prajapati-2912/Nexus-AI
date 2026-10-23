import 'package:flutter/material.dart';
import '../../domain/entities/financial_health.dart';

class FinanceAISummary extends StatelessWidget {
  final FinancialHealth health;

  const FinanceAISummary({super.key, required this.health});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Executive Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(health.summaryReasoning, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
