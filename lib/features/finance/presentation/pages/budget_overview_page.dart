import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_card.dart';
import '../widgets/finance_skeleton.dart';

class BudgetOverviewPage extends StatefulWidget {
  const BudgetOverviewPage({super.key});

  @override
  State<BudgetOverviewPage> createState() => _BudgetOverviewPageState();
}

class _BudgetOverviewPageState extends State<BudgetOverviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(const LoadBudgetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Management'),
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
              return const Center(child: Text('No active budgets set.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
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

          return const Center(child: Text('Pull to load budgets.'));
        },
      ),
    );
  }
}
