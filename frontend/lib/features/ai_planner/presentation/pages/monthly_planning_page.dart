import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/deadline_risk.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';

class MonthlyPlanningPage extends StatefulWidget {
  const MonthlyPlanningPage({super.key});

  @override
  State<MonthlyPlanningPage> createState() => _MonthlyPlanningPageState();
}

class _MonthlyPlanningPageState extends State<MonthlyPlanningPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AIPlannerBloc>();
    if (bloc.state is! AIPlannerLoadedState || (bloc.state as AIPlannerLoadedState).deadlineRisk == null) {
      bloc.add(const LoadDeadlineAnalysisEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Planning'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState && (state.loadingMessage?.contains('Deadline') ?? false)) {
            return const Center(child: CircularProgressIndicator());
          }

          final loadedState = state is AIPlannerLoadedState ? state : null;
          final risk = loadedState?.deadlineRisk;
          final List<CriticalDeadlineItem> milestones = [
            if (risk != null) ...risk.criticalDeadlines,
            if (risk != null) ...risk.upcomingDeadlines,
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(120),
                    borderRadius: BorderRadius.circular(16),
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
                              'Monthly Academic Blueprint',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              milestones.isNotEmpty
                                  ? '${milestones.length} major deadlines and milestones tracked this month.'
                                  : 'Track major exams, term projects, and milestones dynamically.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Major Academic Milestones',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (milestones.isEmpty)
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
                        Icon(Icons.flag_outlined, size: 40, color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text(
                          'No Academic Milestones',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'No critical deadlines or exam milestones are scheduled for this month.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context.push(RouteNames.aiPlannerGeneratePlan),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Generate AI Blueprint'),
                        ),
                      ],
                    ),
                  )
                else
                  ...milestones.map((m) {
                    final color = m.riskLevel.toUpperCase() == 'CRITICAL' || m.riskLevel.toUpperCase() == 'HIGH'
                        ? Colors.redAccent
                        : (m.riskLevel.toUpperCase() == 'MODERATE' ? Colors.orangeAccent : const Color(0xFF10B981));
                    final dateStr = '${m.dueDate.day}/${m.dueDate.month}/${m.dueDate.year}';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: Icon(Icons.flag_rounded, color: color, size: 24),
                        title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Target: $dateStr • ${m.warningMessage}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${m.riskLevel.toUpperCase()} RISK',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                          ),
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
