import 'package:flutter/material.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/budget.dart';
import '../widgets/budget_progress_widget.dart';

class BudgetDetailsPage extends StatelessWidget {
  final Budget? budget;

  const BudgetDetailsPage({super.key, this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (budget == null) {
      return BaseScaffold(
        appBar: AppBar(title: const Text('Budget Details')),
        body: const Center(
          child: Text('No budget selected or found.'),
        ),
      );
    }

    final item = budget!;

    return BaseScaffold(
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
                    _RowItem(label: 'Total Budget Limit', value: '₹${item.totalLimit.toStringAsFixed(2)}'),
                    const Divider(),
                    _RowItem(label: 'Current Total Spent', value: '₹${item.currentSpent.toStringAsFixed(2)}'),
                    const Divider(),
                    _RowItem(
                      label: 'Remaining Balance',
                      value: item.remainingAmount < 0
                          ? '-₹${(-item.remainingAmount).toStringAsFixed(2)}'
                          : '₹${item.remainingAmount.toStringAsFixed(2)}',
                      color: item.isOverBudget ? Colors.redAccent : const Color(0xFF10B981),
                    ),
                    const Divider(),
                    _RowItem(label: 'Period Type', value: item.period),
                    const Divider(),
                    const _RowItem(label: 'Alert Threshold', value: '80% & 100% Alerts Active'),
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
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
