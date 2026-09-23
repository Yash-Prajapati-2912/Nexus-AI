import 'package:flutter/material.dart';
import 'radial_budget_painter.dart';

class BudgetHealthCard extends StatelessWidget {
  final double plannedAmount;
  final double currentSpent;
  final String currencySymbol;
  final VoidCallback? onSetBudgetTap;

  const BudgetHealthCard({
    super.key,
    required this.plannedAmount,
    required this.currentSpent,
    this.currencySymbol = '₹',
    this.onSetBudgetTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (plannedAmount <= 0) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.pie_chart_outline_rounded, color: theme.colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No Active Budget Set', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      'Set a monthly limit to enable daily safe spending caps & overflow alerts.',
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSetBudgetTap,
                child: const Text('Set Budget'),
              ),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysRemaining = (daysInMonth - now.day + 1).clamp(1, daysInMonth);
    final remainingBudget = plannedAmount - currentSpent;
    final dailySafeSpending = (remainingBudget > 0) ? (remainingBudget / daysRemaining) : 0.0;

    final dailyRunRate = now.day > 0 ? (currentSpent / now.day) : 0.0;
    final projectedMonthEnd = dailyRunRate * daysInMonth;
    final isProjectedOver = projectedMonthEnd > plannedAmount;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E1E2E), const Color(0xFF2A2A3E)]
                : [Colors.white, const Color(0xFFF8FAFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget Health',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: onSetBudgetTap,
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit Budget'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                RadialBudgetWidget(
                  plannedAmount: plannedAmount,
                  currentSpent: currentSpent,
                  currencySymbol: currencySymbol,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HealthMetricItem(
                        icon: Icons.calendar_today_rounded,
                        label: 'Days Remaining',
                        value: '$daysRemaining days',
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      _HealthMetricItem(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'Daily Safe Limit',
                        value: '$currencySymbol${dailySafeSpending.toStringAsFixed(0)}/day',
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(height: 10),
                      _HealthMetricItem(
                        icon: Icons.auto_graph_rounded,
                        label: 'Projected Month-End',
                        value: '$currencySymbol${projectedMonthEnd.toStringAsFixed(0)}',
                        color: isProjectedOver ? Colors.redAccent : Colors.indigoAccent,
                        subText: isProjectedOver
                            ? 'Over budget by $currencySymbol${(projectedMonthEnd - plannedAmount).toStringAsFixed(0)}'
                            : 'On track to save $currencySymbol${(plannedAmount - projectedMonthEnd).toStringAsFixed(0)}',
                      ),
                    ],
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

class _HealthMetricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subText;

  const _HealthMetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    final subColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, color: subColor)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        if (subText != null)
          Text(subText!, style: TextStyle(fontSize: 10, color: color.withAlpha(200), fontWeight: FontWeight.w500)),
      ],
    );
  }
}
