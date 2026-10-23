import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_card.dart';
import '../widgets/finance_skeleton.dart';

import '../../../../shared/widgets/base_scaffold.dart';

class BudgetOverviewPage extends StatefulWidget {
  const BudgetOverviewPage({super.key});

  @override
  State<BudgetOverviewPage> createState() => _BudgetOverviewPageState();
}

class _BudgetOverviewPageState extends State<BudgetOverviewPage> {
  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() {
    context.read<BudgetBloc>().add(const LoadBudgetsEvent());
  }

  Future<void> _openCreateBudget() async {
    await context.push(RouteNames.financeCreateBudget);
    if (mounted) {
      _loadBudgets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Budget Management', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateBudget,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Set Budget'),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 120),
            );
          }

          if (state is BudgetLoadedState) {
            if (state.budgets.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pie_chart_outline_rounded, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No active budgets set for this month',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Establish a monthly spending limit to track expenses and prevent overspending.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _openCreateBudget,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Set Monthly Budget'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              itemCount: state.budgets.length,
              itemBuilder: (context, index) {
                final b = state.budgets[index];
                return BudgetCard(
                  budget: b,
                  onTap: () => context.push(RouteNames.financeBudgetDetails, extra: b),
                );
              },
            );
          }

          return Center(
            child: ElevatedButton.icon(
              onPressed: _openCreateBudget,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Set Monthly Budget'),
            ),
          );
        },
      ),
    );
  }
}
