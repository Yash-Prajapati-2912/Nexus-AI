import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';

class FinanceFilterPage extends StatefulWidget {
  const FinanceFilterPage({super.key});

  @override
  State<FinanceFilterPage> createState() => _FinanceFilterPageState();
}

class _FinanceFilterPageState extends State<FinanceFilterPage> {
  RangeValues _amountRange = const RangeValues(0, 2000);
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Amount Range', style: TextStyle(fontWeight: FontWeight.bold)),
            RangeSlider(
              values: _amountRange,
              min: 0,
              max: 5000,
              divisions: 50,
              labels: RangeLabels(
                '\$${_amountRange.start.toInt()}',
                '\$${_amountRange.end.toInt()}',
              ),
              onChanged: (val) => setState(() => _amountRange = val),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<ExpenseBloc>().add(LoadExpensesEvent(
                        minAmount: _amountRange.start,
                        maxAmount: _amountRange.end,
                        categoryId: _selectedCategory,
                      ));
                  context.pop();
                },
                child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
