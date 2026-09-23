import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/ai_mentor_section_widget.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/expense_chart_widget.dart';
import '../widgets/finance_summary_widget.dart';
import '../widgets/planner_summary_widget.dart';
import '../widgets/productivity_section_widget.dart';
import '../widgets/recent_activity_widget.dart';
import '../widgets/skeleton_dashboard_widget.dart';
import '../widgets/task_completion_chart_widget.dart';
import '../widgets/task_priority_chart_widget.dart';
import '../widgets/task_status_donut_chart.dart';
import '../widgets/weekly_study_chart_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go(RouteNames.dashboard),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.indigoAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Nexus AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'My Profile',
            onPressed: () => context.push(RouteNames.profile),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => context.read<DashboardBloc>().add(RefreshDashboardEvent()),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoadingState || state is DashboardInitialState) {
            return const SkeletonDashboardWidget();
          }

          if (state is DashboardErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppErrorCard(
                  message: state.message,
                  onRetry: () => context.read<DashboardBloc>().add(RetryLoadDashboardEvent()),
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

          final activeTasks = tasks.where((t) => t.status != TaskStatus.completed).toList();
          final highPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.high || t.priority == TaskPriority.urgent).length;
          final mediumPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.medium).length;
          final lowPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.low).length;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeaderWidget(user: dashboard.user),
                  const SizedBox(height: 20),
                  // 1. Task Overview (Donut Chart)
                  TaskStatusDonutChart(tasks: tasks),
                  const SizedBox(height: 20),
                  // 2. Task Priority Distribution (Horizontal progress bars)
                  TaskPriorityChartWidget(
                    highPriorityCount: highPriorityCount,
                    mediumPriorityCount: mediumPriorityCount,
                    lowPriorityCount: lowPriorityCount,
                  ),
                  const SizedBox(height: 20),
                  // 3. Smart Planner Summary
                  PlannerSummaryWidget(tasks: tasks),
                  const SizedBox(height: 20),
                  FinanceSummaryWidget(summary: dashboard.financeSummary),
                  const SizedBox(height: 20),
                  AiMentorSectionWidget(insight: dashboard.aiInsight),
                  const SizedBox(height: 20),
                  ProductivitySectionWidget(stats: dashboard.productivityStats),
                  const SizedBox(height: 20),
                  RecentActivityWidget(notificationSummary: dashboard.notificationSummary),
                  const SizedBox(height: 20),
                  WeeklyStudyChartWidget(data: dashboard.chartData.weeklyStudyHours),
                  const SizedBox(height: 20),
                  ExpenseChartWidget(data: dashboard.chartData.categoryExpenses),
                  const SizedBox(height: 20),
                  TaskCompletionChartWidget(data: dashboard.chartData.taskCompletionTrend),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

