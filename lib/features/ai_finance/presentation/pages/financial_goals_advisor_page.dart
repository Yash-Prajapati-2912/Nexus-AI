import 'package:flutter/material.dart';
import '../../domain/entities/goal_analysis.dart';
import '../widgets/goal_progress_card.dart';

class FinancialGoalsAdvisorPage extends StatelessWidget {
  const FinancialGoalsAdvisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GoalAnalysis> goals = [
      GoalAnalysis(
        goalId: 'g1',
        goalTitle: 'Emergency Savings Fund',
        currentProgressPercentage: 75.0,
        riskLevel: 'LOW',
        predictedCompletionDate: DateTime.now().add(const Duration(days: 60)),
        recommendedMonthlyContribution: 100,
        aiOptimizationTip: 'On schedule! Maintain current \$100 monthly contributions.',
      ),
      GoalAnalysis(
        goalId: 'g2',
        goalTitle: 'New Laptop Replacement',
        currentProgressPercentage: 40.0,
        riskLevel: 'MODERATE',
        predictedCompletionDate: DateTime.now().add(const Duration(days: 90)),
        recommendedMonthlyContribution: 150,
        aiOptimizationTip: 'Increase monthly contribution by \$25 to meet October target.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Goals Advisor')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          return GoalProgressCard(goal: goals[index]);
        },
      ),
    );
  }
}

