import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/weekly_heatmap_widget.dart';

class WeeklyPlanningPage extends StatelessWidget {
  const WeeklyPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Planning'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          final loadedState = state is AIPlannerLoadedState ? state : null;
          final trends = loadedState?.productivityInsight?.weeklyTrends;

          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          final Map<String, int> heatmap = {};
          if (trends != null && trends.isNotEmpty) {
            for (int i = 0; i < days.length && i < trends.length; i++) {
              heatmap[days[i]] = trends[i].round().clamp(0, 4);
            }
          }

          final plan = loadedState?.currentStudyPlan;
          final items = plan?.actionItems ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeeklyHeatmapWidget(heatmapData: heatmap),
                const SizedBox(height: 24),
                Text(
                  'AI Time-Blocked Schedule',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 40, color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text(
                          'No Active Weekly Study Plan',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Generate an AI study plan to create a personalized, time-blocked schedule for your subjects.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.push(RouteNames.aiPlannerGeneratePlan),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Generate Study Plan'),
                        ),
                      ],
                    ),
                  )
                else
                  ...items.map((item) {
                    final hoursStr = item.allocatedMinutes >= 60
                        ? '${(item.allocatedMinutes / 60).toStringAsFixed(1)} hrs'
                        : '${item.allocatedMinutes} mins';
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            '${item.step}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          ),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • Due: ${item.targetDate.day}/${item.targetDate.month}/${item.targetDate.year}'),
                        trailing: Text(
                          hoursStr,
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
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
}
