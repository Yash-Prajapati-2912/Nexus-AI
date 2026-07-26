import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/finance_skeleton.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RouteNames.financeSearch),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => context.push(RouteNames.financeFilter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.financeAddExpense),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 100),
            );
          }

          if (state is ExpenseLoadedState) {
            if (state.expenses.isEmpty) {
              return const Center(child: Text('No expenses recorded yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final exp = state.expenses[index];
                return ExpenseCard(
                  expense: exp,
                  onTap: () => context.push(RouteNames.financeExpenseDetails, extra: exp),
                );
              },
            );
          }

          return const Center(child: Text('Pull to load expenses.'));
        },
      ),
    );
  }
}
