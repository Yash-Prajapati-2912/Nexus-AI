import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/deadline_risk.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/risk_card.dart';

class DeadlineRiskPage extends StatefulWidget {
  const DeadlineRiskPage({super.key});

  @override
  State<DeadlineRiskPage> createState() => _DeadlineRiskPageState();
}

class _DeadlineRiskPageState extends State<DeadlineRiskPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const LoadDeadlineAnalysisEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deadline Risk Analysis'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: AISkeletonLoader(height: 200),
            );
          }

          final risk = (state is AIPlannerLoadedState && state.deadlineRisk != null)
              ? state.deadlineRisk!
              : DeadlineRisk(
                  overallLateRiskPercentage: 35.0,
                  criticalDeadlines: [
                    CriticalDeadlineItem(
                      taskId: 'task-101',
                      title: 'Machine Learning Term Paper',
                      dueDate: DateTime.now().add(const Duration(days: 1)),
                      lateProbability: 0.78,
                      riskLevel: 'CRITICAL',
                      warningMessage: 'Estimated 8 hours needed, but only 3 hours available before deadline.',
                    ),
                  ],
                  upcomingDeadlines: [
                    CriticalDeadlineItem(
                      taskId: 'task-102',
                      title: 'Software Engineering Sprint Review',
                      dueDate: DateTime.now().add(const Duration(days: 3)),
                      lateProbability: 0.25,
                      riskLevel: 'MODERATE',
                      warningMessage: 'Dependencies pending group member contribution.',
                    ),
                  ],
                  warningCards: [
                    'High submission volume due on Thursday.',
                    'Consider rescheduling low-priority tasks to weekend.',
                  ],
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Risk Gauge Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        risk.overallLateRiskPercentage >= 50
                            ? Colors.red.shade900.withAlpha(180)
                            : Colors.orange.shade900.withAlpha(180),
                        theme.colorScheme.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: risk.overallLateRiskPercentage >= 50 ? Colors.redAccent : Colors.orangeAccent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: risk.overallLateRiskPercentage / 100.0,
                              strokeWidth: 8,
                              backgroundColor: Colors.white24,
                              color: risk.overallLateRiskPercentage >= 50 ? Colors.redAccent : Colors.orangeAccent,
                            ),
                          ),
                          Text(
                            '${risk.overallLateRiskPercentage.toInt()}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Late Risk',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              risk.overallLateRiskPercentage >= 50
                                  ? 'Urgent schedule adjustments needed to prevent missed submissions.'
                                  : 'Schedule is manageable with minor adjustments.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Critical Risk Items',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...risk.criticalDeadlines.map((item) => RiskCard(deadlineItem: item)),

                const SizedBox(height: 24),
                Text(
                  'Upcoming Deadlines',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...risk.upcomingDeadlines.map((item) => RiskCard(deadlineItem: item)),

                const SizedBox(height: 24),
                Text(
                  'AI Warnings & Mitigations',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...risk.warningCards.map(
                  (warn) => Card(
                    color: theme.colorScheme.errorContainer.withAlpha(80),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: theme.colorScheme.error),
                          const SizedBox(width: 10),
                          Expanded(child: Text(warn, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
