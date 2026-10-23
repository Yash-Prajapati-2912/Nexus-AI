import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/priority_optimizer.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/priority_badge.dart';
import '../widgets/priority_matrix_widget.dart';

class PriorityOptimizerPage extends StatefulWidget {
  const PriorityOptimizerPage({super.key});

  @override
  State<PriorityOptimizerPage> createState() => _PriorityOptimizerPageState();
}

class _PriorityOptimizerPageState extends State<PriorityOptimizerPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const OptimizePrioritiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Priority Optimizer'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: AISkeletonLoader(height: 250),
            );
          }

          final optimizer = (state is AIPlannerLoadedState && state.priorityOptimizer != null)
              ? state.priorityOptimizer!
              : PriorityOptimizer(
                  highestPriorityTasks: [
                    PrioritizedTaskItem(
                      id: 'task-1',
                      title: 'Algorithms Final Project Report',
                      priorityLevel: 'CRITICAL',
                      deadline: DateTime.now().add(const Duration(days: 1)),
                      estimatedMinutes: 120,
                      priorityExplanation: 'Weighted 25% of final course grade & due in 24 hours.',
                      recommendedOrder: 1,
                    ),
                    PrioritizedTaskItem(
                      id: 'task-2',
                      title: 'Database Normalization Quiz Prep',
                      priorityLevel: 'HIGH',
                      deadline: DateTime.now().add(const Duration(days: 2)),
                      estimatedMinutes: 60,
                      priorityExplanation: 'Prerequisite for tomorrow laboratory exam.',
                      recommendedOrder: 2,
                    ),
                  ],
                  urgentDeadlines: [
                    PrioritizedTaskItem(
                      id: 'task-3',
                      title: 'Submit Lab Safety Agreement Form',
                      priorityLevel: 'HIGH',
                      deadline: DateTime.now().add(const Duration(hours: 8)),
                      estimatedMinutes: 15,
                      priorityExplanation: 'Immediate deadline before lab entry.',
                      recommendedOrder: 3,
                    ),
                  ],
                  totalEstimatedTimeMinutes: 195,
                  overallExplanation:
                      'AI evaluated your 3 active tasks based on grade weight, time-to-deadline, and estimated focus effort.',
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(150),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Estimated Focus Time',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text(
                              '${(optimizer.totalEstimatedTimeMinutes / 60).toStringAsFixed(1)} Hours Total',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              optimizer.overallExplanation,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                PriorityMatrixWidget(optimizer: optimizer),

                const SizedBox(height: 24),
                Text(
                  'Recommended Execution Order',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...optimizer.highestPriorityTasks.map((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: theme.colorScheme.primary,
                                child: Text(
                                  '#${item.recommendedOrder}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              PriorityBadge(priority: item.priorityLevel),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.priorityExplanation,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Text('${item.estimatedMinutes} mins est.', style: theme.textTheme.labelSmall),
                              const Spacer(),
                              Icon(Icons.event_outlined, size: 14, color: theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Text('Due: ${_formatDate(item.deadline)}', style: theme.textTheme.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
