import 'package:flutter/material.dart';

class AmountBadge extends StatelessWidget {
  final double amount;
  final bool isExpense;
  final String currencySymbol;

  const AmountBadge({
    super.key,
    required this.amount,
    this.isExpense = true,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? Colors.redAccent : const Color(0xFF10B981);
    final prefix = isExpense ? '-' : '+';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100), width: 1),
      ),
      child: Text(
        '$prefix$currencySymbol${amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
