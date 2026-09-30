import 'package:flutter/material.dart';
import '../../../../di/injection_container.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/i_finance_repository.dart';
import '../widgets/transaction_card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'ALL';
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final repo = getIt<IFinanceRepository>();
    final result = await repo.getTransactions();
    if (mounted) {
      result.fold(
        (_) => setState(() => _isLoading = false),
        (txs) => setState(() {
          _transactions = txs;
          _isLoading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _transactions.where((t) {
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
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF6366F1);
                  }
                  return Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E293B)
                      : Colors.grey.shade200;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87;
                }),
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.black12,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(transaction: filtered[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
