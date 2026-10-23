import 'package:flutter/material.dart';
import '../../utils/budget_health_calculator.dart';
import 'radial_budget_painter.dart';

class BudgetHealthCard extends StatelessWidget {
  final double plannedAmount;
  final double currentSpent;
  final String currencySymbol;
  final VoidCallback? onSetBudgetTap;
  final DateTime? currentDate;
  final int? daysInMonth;
  final int? elapsedDays;
  final int? remainingDays;

  const BudgetHealthCard({
    super.key,
    required this.plannedAmount,
    required this.currentSpent,
    this.currencySymbol = '₹',
    this.onSetBudgetTap,
    this.currentDate,
    this.daysInMonth,
    this.elapsedDays,
    this.remainingDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (plannedAmount <= 0) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.pie_chart_outline_rounded, color: theme.colorScheme.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('No Active Budget Set', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 3),
                            Text(
                              'Set a monthly limit to enable daily safe spending caps & overflow alerts.',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      if (!isNarrow) ...[
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onSetBudgetTap,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text('Set Budget', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ],
                  ),
                  if (isNarrow) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onSetBudgetTap,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('Set Budget', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      );
    }

    final result = BudgetHealthCalculator.calculate(
      monthlyBudget: plannedAmount,
      currentSpent: currentSpent,
      currentDate: currentDate,
      daysInMonth: daysInMonth,
      elapsedDays: elapsedDays,
      remainingDays: remainingDays,
    );

    final isProjectedOver = (result.projectedMonthEnd != null) && (result.projectedMonthEnd! > plannedAmount);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(18),
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: onSetBudgetTap,
                  icon: const Icon(Icons.edit_rounded, size: 15),
                  label: const Text('Edit Budget', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final metrics = [
                  _HealthMetricItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Days Remaining',
                    value: '${result.remainingDays} ${result.remainingDays == 1 ? 'day' : 'days'}',
                    color: theme.colorScheme.primary,
                    subText: '${result.totalDaysInMonth}-day month',
                  ),
                  const SizedBox(height: 8),
                  _HealthMetricItem(
                    icon: Icons.today_rounded,
                    label: 'Daily Budget',
                    value: '$currencySymbol${result.normalDailyBudget.toStringAsFixed(0)}/day',
                    color: Colors.blueAccent,
                    subText: 'Monthly daily average',
                  ),
                  const SizedBox(height: 8),
                  _HealthMetricItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: result.remainingDays == 1 ? 'Safe to Spend Today' : 'Safe to Spend / Day',
                    value: '$currencySymbol${result.safeDailyLimit.toStringAsFixed(0)}/day',
                    color: result.safeDailyLimit > 0 ? const Color(0xFF10B981) : Colors.redAccent,
                    subText: result.remainingDays == 1
                        ? 'Final day buffer'
                        : 'Safe per remaining day',
                  ),
                  const SizedBox(height: 8),
                  _HealthMetricItem(
                    icon: Icons.auto_graph_rounded,
                    label: 'Projected Month-End',
                    value: result.projectedMonthEnd != null
                        ? '$currencySymbol${result.projectedMonthEnd!.toStringAsFixed(0)}'
                        : 'No spending yet',
                    color: isProjectedOver
                        ? Colors.redAccent
                        : (result.projectedMonthEnd != null ? Colors.indigoAccent : Colors.grey),
                    subText: result.projectedMonthEnd != null
                        ? (isProjectedOver
                            ? 'Over budget by $currencySymbol${(result.projectedMonthEnd! - plannedAmount).toStringAsFixed(0)}'
                            : 'On track to save $currencySymbol${(plannedAmount - result.projectedMonthEnd!).toStringAsFixed(0)}')
                        : null,
                  ),
                ];

                if (isNarrow) {
                  return Column(
                    children: [
                      Center(
                        child: RadialBudgetWidget(
                          plannedAmount: plannedAmount,
                          currentSpent: currentSpent,
                          currencySymbol: currencySymbol,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...metrics,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        children: metrics,
                      ),
                    ),
                  ],
                );
              },
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
