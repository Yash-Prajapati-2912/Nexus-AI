import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/design_system/widgets/error_states/app_error_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/ai_mentor_section_widget.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/expense_chart_widget.dart';
import '../widgets/finance_summary_widget.dart';
import '../widgets/planner_summary_widget.dart';
import '../widgets/productivity_section_widget.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/recent_activity_widget.dart';
import '../widgets/skeleton_dashboard_widget.dart';
import '../widgets/task_completion_chart_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexus AI Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
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

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeaderWidget(user: dashboard.user),
                  const SizedBox(height: 20),
                  const QuickActionsWidget(),
                  const SizedBox(height: 20),
                  TodayOverviewWidget(summary: dashboard.plannerSummary),
                  const SizedBox(height: 20),
                  PlannerSummaryWidget(summary: dashboard.plannerSummary),
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
