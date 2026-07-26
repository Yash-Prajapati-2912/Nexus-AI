import 'package:flutter/material.dart';
import '../../domain/entities/subscription_analysis.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionAnalysis analysis;
  final VoidCallback? onTap;

  const SubscriptionCard({super.key, required this.analysis, this.onTap});

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
                      const Icon(Icons.subscriptions_rounded, color: Colors.orangeAccent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Subscription Audit',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '\$${analysis.totalMonthlySubscriptionCost.toStringAsFixed(2)}/mo',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Pill(label: '${analysis.activeSubscriptionCount} Active', color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  if (analysis.unusedCount > 0)
                    _Pill(
                      label: '${analysis.unusedCount} Unused (Save \$${analysis.potentialMonthlySavingsFromCancellation.toStringAsFixed(0)}/mo)',
                      color: Colors.redAccent,
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

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
