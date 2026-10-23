import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/expense.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class ExpenseDetailsPage extends StatelessWidget {
  final Expense? expense;

  const ExpenseDetailsPage({super.key, this.expense});

  void _onDelete(BuildContext context, Expense item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ExpenseBloc>().add(DeleteExpenseEvent(item.id));
              context.pop(true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _onDuplicate(BuildContext context, Expense item) {
    final dup = item.copyWith(
      id: '',
      title: '${item.title} (Copy)',
      date: DateTime.now(),
    );
    context.read<ExpenseBloc>().add(CreateExpenseEvent(dup));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense duplicated!')),
    );
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (expense == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Expense Details')),
        body: const Center(child: Text('No expense selected.')),
      );
    }

    final theme = Theme.of(context);
    final item = expense!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            onPressed: () => _onDuplicate(context, item),
            tooltip: 'Duplicate',
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              final result = await context.push(RouteNames.financeEditExpense, extra: item);
              if (result == true && context.mounted) {
                context.pop(true);
              }
            },
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () => _onDelete(context, item),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: Colors.redAccent, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '-₹${item.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            _DetailRow(label: 'Category', value: item.categoryName, icon: Icons.category_rounded),
            _DetailRow(label: 'Date', value: '${item.date.day}/${item.date.month}/${item.date.year}', icon: Icons.calendar_today_rounded),
            _DetailRow(label: 'Payment Method', value: item.paymentMethod, icon: Icons.credit_card_rounded),
            _DetailRow(label: 'Status', value: item.status, icon: Icons.check_circle_outline_rounded),
            _DetailRow(label: 'Recurring', value: item.isRecurring ? 'Yes (${item.recurringPeriod ?? "MONTHLY"})' : 'No', icon: Icons.replay_rounded),
            if (item.note != null && item.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Notes', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(item.note!, style: theme.textTheme.bodyMedium),
            ],
            if (item.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Tags', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: item.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
