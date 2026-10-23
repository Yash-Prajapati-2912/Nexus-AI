import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';

class FinanceSearchPage extends StatefulWidget {
  const FinanceSearchPage({super.key});

  @override
  State<FinanceSearchPage> createState() => _FinanceSearchPageState();
}

class _FinanceSearchPageState extends State<FinanceSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch(String query) {
    context.read<ExpenseBloc>().add(LoadExpensesEvent(search: query));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search expenses, income, categories...',
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoadedState) {
            if (state.expenses.isEmpty) {
              return const Center(child: Text('No results matching your query.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                return ExpenseCard(expense: state.expenses[index]);
              },
            );
          }
          return const Center(child: Text('Type to search financial records.'));
        },
      ),
    );
  }
}
