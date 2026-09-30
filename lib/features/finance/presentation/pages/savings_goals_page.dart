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
        onPressed: () async {
          final bloc = context.read<SavingsBloc>();
          await context.push(RouteNames.financeCreateSavingsGoal);
          if (mounted) {
            bloc.add(const LoadSavingsGoalsEvent());
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
      body: BlocConsumer<SavingsBloc, SavingsState>(
        listener: (context, state) {
          if (state is SavingsFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is SavingsOperationSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SavingsLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 120),
            );
          }

          if (state is SavingsLoadedState) {
            if (state.goals.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SavingsBloc>().add(const LoadSavingsGoalsEvent());
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const Center(child: Text('No savings goals created yet.')),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SavingsBloc>().add(const LoadSavingsGoalsEvent());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
              ),
            );
          }

          if (state is SavingsOperationSuccessState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: FinanceSkeleton(height: 120),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<SavingsBloc>().add(const LoadSavingsGoalsEvent());
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Pull to load savings goals.'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<SavingsBloc>().add(const LoadSavingsGoalsEvent()),
                        child: const Text('Load Goals'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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
                this.context.read<SavingsBloc>().add(AddSavingsContributionEvent(goalId: goalId, amount: amt));
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
