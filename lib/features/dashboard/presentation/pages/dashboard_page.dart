import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../planner/domain/entities/task_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/ai_finance_insight_widget.dart';
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
import '../widgets/today_overview_widget.dart';
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
        title: NexusLogo(
          variant: LogoVariant.full,
          markSize: 26,
          fontSize: 18,
          logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
          onTap: () => context.go(RouteNames.dashboard),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'My Profile',
            onPressed: () => context.push(RouteNames.profile),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Dashboard',
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
          final completedTasksCount = tasks.where((t) => t.status == TaskStatus.completed).length;
          final highPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.high || t.priority == TaskPriority.urgent).length;
          final mediumPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.medium).length;
          final lowPriorityCount = activeTasks.where((t) => t.priority == TaskPriority.low).length;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Personalized Header
                  DashboardHeaderWidget(user: dashboard.user),
                  const SizedBox(height: 20),

                  // 2. Key Overview Real-Time Metrics Grid
                  KeyMetricsOverviewWidget(
                    activeTasksCount: activeTasks.length,
                    urgentTasksCount: highPriorityCount,
                    completedTasksCount: completedTasksCount,
                    totalTasksCount: tasks.length,
                    spentThisMonth: dashboard.financeSummary.spentThisMonth,
                    remainingBudget: dashboard.financeSummary.remainingBudget,
                  ),
                  const SizedBox(height: 24),

                  // 3-8 Responsive Composition
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1100;

                      if (isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Main Column (60% width)
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PlannerSummaryWidget(tasks: tasks),
                                  const SizedBox(height: 24),
                                  TaskStatusDonutChart(tasks: tasks),
                                  const SizedBox(height: 24),
                                  TaskPriorityChartWidget(
                                    highPriorityCount: highPriorityCount,
                                    mediumPriorityCount: mediumPriorityCount,
                                    lowPriorityCount: lowPriorityCount,
                                  ),
                                  const SizedBox(height: 24),
                                  TaskCompletionChartWidget(data: dashboard.chartData.taskCompletionTrend),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Right Secondary Column (40% width)
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FinanceSummaryWidget(summary: dashboard.financeSummary),
                                  const SizedBox(height: 24),
                                  AiFinanceInsightWidget(summary: dashboard.financeSummary),
                                  const SizedBox(height: 24),
                                  ExpenseChartWidget(data: dashboard.chartData.categoryExpenses),
                                  const SizedBox(height: 24),
                                  AiMentorSectionWidget(insight: dashboard.aiInsight),
                                  const SizedBox(height: 24),
                                  ProductivitySectionWidget(stats: dashboard.productivityStats),
                                  const SizedBox(height: 24),
                                  WeeklyStudyChartWidget(data: dashboard.chartData.weeklyStudyHours),
                                  const SizedBox(height: 24),
                                  RecentActivityWidget(notificationSummary: dashboard.notificationSummary),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Tablet / Mobile Layout
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PlannerSummaryWidget(tasks: tasks),
                            const SizedBox(height: 20),
                            FinanceSummaryWidget(summary: dashboard.financeSummary),
                            const SizedBox(height: 20),
                            AiFinanceInsightWidget(summary: dashboard.financeSummary),
                            const SizedBox(height: 20),
                            TaskStatusDonutChart(tasks: tasks),
                            const SizedBox(height: 20),
                            TaskPriorityChartWidget(
                              highPriorityCount: highPriorityCount,
                              mediumPriorityCount: mediumPriorityCount,
                              lowPriorityCount: lowPriorityCount,
                            ),
                            const SizedBox(height: 20),
                            ExpenseChartWidget(data: dashboard.chartData.categoryExpenses),
                            const SizedBox(height: 20),
                            AiMentorSectionWidget(insight: dashboard.aiInsight),
                            const SizedBox(height: 20),
                            ProductivitySectionWidget(stats: dashboard.productivityStats),
                            const SizedBox(height: 20),
                            WeeklyStudyChartWidget(data: dashboard.chartData.weeklyStudyHours),
                            const SizedBox(height: 20),
                            TaskCompletionChartWidget(data: dashboard.chartData.taskCompletionTrend),
                            const SizedBox(height: 20),
                            RecentActivityWidget(notificationSummary: dashboard.notificationSummary),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
