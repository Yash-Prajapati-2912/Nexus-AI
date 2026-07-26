import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({super.key, required this.forecast});

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
              children: [
                const Icon(Icons.timeline_rounded, color: Colors.purpleAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Expense Forecast',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(forecast.forecastExplanation, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _Box(
                    label: 'Next 7 Days',
                    amount: '\$${forecast.nextWeekForecastAmount.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Box(
                    label: 'Next 30 Days',
                    amount: '\$${forecast.nextMonthForecastAmount.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Box(
                    label: 'Est. Savings',
                    amount: '\$${forecast.predictedMonthEndSavings.toStringAsFixed(0)}',
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String amount;
  final Color? color;

  const _Box({required this.label, required this.amount, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            amount,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: c),
          ),
        ],
      ),
    );
  }
}
