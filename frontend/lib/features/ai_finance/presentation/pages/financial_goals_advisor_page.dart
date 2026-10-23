import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/goal_analysis.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';
import '../widgets/goal_progress_card.dart';

class FinancialGoalsAdvisorPage extends StatefulWidget {
  const FinancialGoalsAdvisorPage({super.key});

  @override
  State<FinancialGoalsAdvisorPage> createState() => _FinancialGoalsAdvisorPageState();
}

class _FinancialGoalsAdvisorPageState extends State<FinancialGoalsAdvisorPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Goals Advisor')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AIFinanceLoadedState) {
            final List<GoalAnalysis> goals = state.goals;

            if (goals.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.savings_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No Active Savings Goals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                        'Create savings goals in the Finance module to unlock AI-powered target completion predictions and contribution recommendations.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return GoalProgressCard(goal: goals[index]);
              },
            );
          }

          return const Center(child: Text('No financial goals data available.'));
        },
      ),
    );
  }
}

