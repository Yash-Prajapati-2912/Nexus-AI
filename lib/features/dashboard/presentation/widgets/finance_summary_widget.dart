import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/expense_card.dart';
import '../../domain/entities/finance_summary_entity.dart';

class FinanceSummaryWidget extends StatelessWidget {
  final FinanceSummaryEntity summary;

  const FinanceSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Finance Summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ExpenseCard(
          category: 'Monthly Spent',
          amount: '\$${summary.spentThisMonth.toStringAsFixed(2)}',
          date: 'Remaining: \$${summary.remainingBudget.toStringAsFixed(2)}',
          icon: Icons.account_balance_wallet_rounded,
        ),
      ],
    );
  }
}
