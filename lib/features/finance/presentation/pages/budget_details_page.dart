import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';
import '../widgets/budget_progress_widget.dart';

class BudgetDetailsPage extends StatelessWidget {
  final Budget? budget;

  const BudgetDetailsPage({super.key, this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = budget ??
        Budget(
          id: 'b-1',
          name: 'Monthly Dining & Food Limit',
          totalLimit: 500.00,
          currentSpent: 380.25,
          period: 'MONTHLY',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BudgetProgressWidget(budget: item),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _RowItem(label: 'Total Budget Limit', value: '\$${item.totalLimit.toStringAsFixed(2)}'),
                    const Divider(),
                    _RowItem(label: 'Current Total Spent', value: '\$${item.currentSpent.toStringAsFixed(2)}'),
                    const Divider(),
                    _RowItem(
                      label: 'Remaining Balance',
                      value: '\$${item.remainingAmount.clamp(0, double.infinity).toStringAsFixed(2)}',
                      color: item.isOverBudget ? Colors.redAccent : const Color(0xFF10B981),
                    ),
                    const Divider(),
                    _RowItem(label: 'Period Type', value: item.period),
                    const Divider(),
                    _RowItem(label: 'Alert Threshold', value: '80% & 100% Alerts Active'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _RowItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
