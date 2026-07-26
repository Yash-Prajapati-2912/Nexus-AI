import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/workload_analysis.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/workload_charts.dart';

class WorkloadAnalysisPage extends StatefulWidget {
  const WorkloadAnalysisPage({super.key});

  @override
  State<WorkloadAnalysisPage> createState() => _WorkloadAnalysisPageState();
}

class _WorkloadAnalysisPageState extends State<WorkloadAnalysisPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const LoadWorkloadAnalysisEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workload Analysis'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  AISkeletonLoader(height: 180),
                  SizedBox(height: 16),
                  AISkeletonLoader(height: 220),
                ],
              ),
            );
          }

          final workload = (state is AIPlannerLoadedState && state.workloadAnalysis != null)
              ? state.workloadAnalysis!
              : const WorkloadAnalysis(
                  currentWorkloadHours: 28.5,
                  busyDaysCount: 2,
                  freeTimeHours: 14.0,
                  studyBalanceScore: 82.0,
                  taskDistribution: {'CS': 6, 'Math': 4, 'Physics': 3},
                  assignmentPressureIndex: 0.65,
                  totalStudyHours: 28.5,
                  difficultyLevel: 'High Load',
                  dailyWorkloads: [
                    DailyWorkload(dayName: 'Monday', studyHours: 5.5, totalTasks: 3, isBusyDay: false),
                    DailyWorkload(dayName: 'Tuesday', studyHours: 7.0, totalTasks: 4, isBusyDay: true),
                    DailyWorkload(dayName: 'Wednesday', studyHours: 3.5, totalTasks: 2, isBusyDay: false),
                    DailyWorkload(dayName: 'Thursday', studyHours: 8.0, totalTasks: 5, isBusyDay: true),
                    DailyWorkload(dayName: 'Friday', studyHours: 4.5, totalTasks: 3, isBusyDay: false),
                  ],
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics overview cards
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _MetricCard(
                      title: 'Workload Hours',
                      value: '${workload.currentWorkloadHours}h',
                      subtitle: 'Difficulty: ${workload.difficultyLevel}',
                      icon: Icons.timer_outlined,
                      color: Colors.blueAccent,
                    ),
                    _MetricCard(
                      title: 'Busy Days',
                      value: '${workload.busyDaysCount} Days',
                      subtitle: '${workload.freeTimeHours}h Free Time',
                      icon: Icons.calendar_month_outlined,
                      color: Colors.orangeAccent,
                    ),
                    _MetricCard(
                      title: 'Study Balance',
                      value: '${workload.studyBalanceScore.toInt()}/100',
                      subtitle: 'Optimal distribution',
                      icon: Icons.balance_rounded,
                      color: const Color(0xFF10B981),
                    ),

                    _MetricCard(
                      title: 'Pressure Index',
                      value: '${(workload.assignmentPressureIndex * 100).toInt()}%',
                      subtitle: 'Assignment urgency',
                      icon: Icons.speed_rounded,
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                WorkloadCharts(workload: workload),

                const SizedBox(height: 24),
                Text(
                  'Task Distribution by Subject',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: workload.taskDistribution.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(entry.key, style: theme.textTheme.bodyMedium),
                          ),
                          Expanded(
                            flex: 7,
                            child: LinearProgressIndicator(
                              value: entry.value / 10.0,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${entry.value} tasks', style: theme.textTheme.labelSmall),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.labelMedium),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
