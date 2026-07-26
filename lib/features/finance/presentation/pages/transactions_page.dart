import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/transaction_card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'ALL';

  final List<Transaction> _sampleTransactions = [
    Transaction(
      id: 'tx-1',
      title: 'University Tuition Fee',
      amount: 1200.00,
      type: TransactionType.expense,
      categoryName: 'Education',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 'tx-2',
      title: 'Teaching Assistant Stipend',
      amount: 850.00,
      type: TransactionType.income,
      categoryName: 'Salary',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 'tx-3',
      title: 'Grocery Store Market',
      amount: 68.40,
      type: TransactionType.expense,
      categoryName: 'Food & Dining',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _sampleTransactions.where((t) {
      if (_selectedFilter == 'EXPENSE') return t.type == TransactionType.expense;
      if (_selectedFilter == 'INCOME') return t.type == TransactionType.income;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Transactions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ALL', label: Text('All')),
                ButtonSegment(value: 'EXPENSE', label: Text('Expenses')),
                ButtonSegment(value: 'INCOME', label: Text('Income')),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (set) {
                setState(() => _selectedFilter = set.first);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return TransactionCard(transaction: filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
