import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection_container.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../../dashboard/presentation/bloc/dashboard_state.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../widgets/statistics_card.dart';

class StatisticsDashboardPage extends StatelessWidget {
  const StatisticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<DashboardBloc>(
      create: (_) => getIt<DashboardBloc>()..add(LoadDashboardEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Statistics Dashboard')),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoadingState || state is DashboardInitialState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load statistics',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(state.message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.read<DashboardBloc>().add(LoadDashboardEvent()),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final dashboard = (state is DashboardLoadedState)
                ? state.dashboard
                : (state as DashboardRefreshingState).currentDashboard;
            final tasks = (state is DashboardLoadedState)
                ? state.tasks
                : (state as DashboardRefreshingState).currentTasks;

            final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;
            final streak = dashboard.productivityStats.streakDays;
            final studyHours = dashboard.productivityStats.studyHoursThisWeek;
            final productivityScore = dashboard.productivityStats.dailyScore;
            final remainingBudget = dashboard.financeSummary.remainingBudget;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Performance Summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      StatisticsCard(label: 'Study Streak', value: '$streak Days', icon: Icons.local_fire_department_rounded, color: Colors.orangeAccent),
                      StatisticsCard(label: 'Total Study Hours', value: '${studyHours.toStringAsFixed(1)} hrs', icon: Icons.schedule_rounded, color: Colors.blueAccent),
                      StatisticsCard(label: 'Productivity Score', value: '$productivityScore/100', icon: Icons.bolt_rounded, color: const Color(0xFF10B981)),
                      StatisticsCard(label: 'Tasks Completed', value: '$completedCount Tasks', icon: Icons.check_circle_rounded, color: Colors.purpleAccent),
                      StatisticsCard(label: 'Remaining Budget', value: '₹${remainingBudget.toStringAsFixed(0)}', icon: Icons.savings_rounded, color: const Color(0xFF10B981)),
                      StatisticsCard(label: 'AI Recommendation', value: dashboard.aiInsight.insight.isNotEmpty ? 'Active' : 'None', icon: Icons.auto_awesome, color: const Color(0xFF6366F1)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
