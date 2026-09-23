import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';
import '../bloc/savings_state.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/savings_goal_card.dart';

import '../../../../shared/widgets/base_scaffold.dart';

class SavingsGoalsPage extends StatefulWidget {
  const SavingsGoalsPage({super.key});

  @override
  State<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
}

class _SavingsGoalsPageState extends State<SavingsGoalsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavingsBloc>().add(const LoadSavingsGoalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.financeCreateSavingsGoal),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state is SavingsLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 120),
            );
          }

          if (state is SavingsLoadedState) {
            if (state.goals.isEmpty) {
              return const Center(child: Text('No savings goals created yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              itemCount: state.goals.length,
              itemBuilder: (context, index) {
                final g = state.goals[index];
                return SavingsGoalCard(
                  goal: g,
                  onTap: () {
                    _showContributionDialog(context, g.id);
                  },
                );
              },
            );
          }

          return const Center(child: Text('Pull to load savings goals.'));
        },
      ),
    );
  }

  void _showContributionDialog(BuildContext context, String goalId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contribution'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount (₹)', prefixText: '₹ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(controller.text.trim()) ?? 0.0;
              if (amt > 0) {
                context.read<SavingsBloc>().add(AddSavingsContributionEvent(goalId: goalId, amount: amt));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
