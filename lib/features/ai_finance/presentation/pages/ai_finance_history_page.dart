import 'package:flutter/material.dart';
import '../../domain/entities/ai_finance_history_item.dart';

class AIFinanceHistoryPage extends StatelessWidget {
  const AIFinanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AIFinanceHistoryItem> items = [
      AIFinanceHistoryItem(id: 'h1', title: 'July 2026 Executive Summary', reportType: 'EXECUTIVE_SUMMARY', createdAt: DateTime.now(), summarySnippet: 'Total savings \$2,450.75'),
      AIFinanceHistoryItem(id: 'h2', title: 'Q2 Spending Anomaly Audit', reportType: 'SPENDING_ANALYSIS', createdAt: DateTime.now().subtract(const Duration(days: 5)), summarySnippet: 'Detected 1 large bookstore transaction'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Finance History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.summarySnippet),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          );
        },
      ),
    );
  }
}

