import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/finance_skeleton.dart';

import '../../../../shared/widgets/base_scaffold.dart';

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
    return BaseScaffold(
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
        onPressed: () async {
          await context.push(RouteNames.financeAddExpense);
          if (context.mounted) context.read<ExpenseBloc>().add(const LoadExpensesEvent());
        },
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final exp = state.expenses[index];
                return ExpenseCard(
                  expense: exp,
                  onTap: () async {
                    await context.push(RouteNames.financeExpenseDetails, extra: exp);
                    if (context.mounted) context.read<ExpenseBloc>().add(const LoadExpensesEvent());
                  },
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
