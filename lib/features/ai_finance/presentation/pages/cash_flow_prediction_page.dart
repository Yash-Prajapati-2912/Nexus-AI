import 'package:flutter/material.dart';

class CashFlowPredictionPage extends StatelessWidget {
  const CashFlowPredictionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Flow Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Projected Cash Flow (90-Day Horizon)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const _RowItem(label: 'Net Cash Inflow', value: '+₹2,450.00', color: Color(0xFF10B981)),
                    const Divider(),
                    const _RowItem(label: 'Net Cash Outflow', value: '-₹820.00', color: Colors.redAccent),
                    const Divider(),
                    _RowItem(label: 'Predicted End Balance', value: '+₹16,300.00', color: theme.colorScheme.primary),
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
  final Color color;

  const _RowItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
