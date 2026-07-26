import 'package:flutter/material.dart';

class FinanceSummaryCard extends StatelessWidget {
  final double totalBalance;
  final double incomeTotal;
  final double expenseTotal;

  const FinanceSummaryCard({
    super.key,
    required this.totalBalance,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(60),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Net Balance',
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withAlpha(220)),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Monthly Income',
                  value: '+\$${incomeTotal.toStringAsFixed(2)}',
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              Expanded(
                child: _MetricItem(
                  label: 'Monthly Expense',
                  value: '-\$${expenseTotal.toStringAsFixed(2)}',
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
