import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/mini_ai_chat_panel.dart';

class AIPlannerHomePage extends StatefulWidget {
  const AIPlannerHomePage({super.key});

  @override
  State<AIPlannerHomePage> createState() => _AIPlannerHomePageState();
}

class _AIPlannerHomePageState extends State<AIPlannerHomePage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AIPlannerBloc>();
    bloc.add(const LoadInsightsEvent());
    bloc.add(const LoadRecommendationsEvent());
  }

  void _openMiniChatPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MiniAIChatPanel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Smart Planner', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.aiPlannerHistory),
            tooltip: 'AI History',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            onPressed: () => context.push(RouteNames.aiPlannerSavedPlans),
            tooltip: 'Saved AI Plans',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RouteNames.aiPlannerSettings),
            tooltip: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openMiniChatPanel,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text('Ask AI Assistant'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AIPlannerBloc>().add(const RefreshInsightsEvent());
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(50),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Nexus AI Engine Ready',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optimize your study routines, prioritize critical deadlines, and analyze workload in seconds.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(230),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.push(RouteNames.aiPlannerGeneratePlan),
                      icon: const Icon(Icons.add_task_rounded),
                      label: const Text('Generate Study Plan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'AI Smart Features',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Feature Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Workload Analysis',
                          description: 'Detect overloaded days & balance schedule',
                          icon: Icons.bar_chart_rounded,
                          color: Colors.blueAccent,
                          onTap: () => context.push(RouteNames.aiPlannerWorkload),
                        ),
                      ),
                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Priority Optimizer',
                          description: 'Smart task sorting based on urgency & effort',
                          icon: Icons.low_priority_rounded,
                          color: Colors.purpleAccent,
                          onTap: () => context.push(RouteNames.aiPlannerPriority),
                        ),
                      ),
                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Deadline Risk Analysis',
                          description: 'Identify high-risk assignments & late probabilities',
                          icon: Icons.warning_amber_rounded,
                          color: Colors.orangeAccent,
                          onTap: () => context.push(RouteNames.aiPlannerDeadlineRisk),
                        ),
                      ),
                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Productivity Insights',
                          description: 'Track streaks, focus time & completion trends',
                          icon: Icons.insights_rounded,
                          color: const Color(0xFF10B981),
                          onTap: () => context.push(RouteNames.aiPlannerInsights),
                        ),
                      ),

                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Weekly & Monthly Planning',
                          description: 'AI recommended schedules for weeks & months',
                          icon: Icons.calendar_month_rounded,
                          color: Colors.teal,
                          onTap: () => context.push(RouteNames.aiPlannerWeekly),
                        ),
                      ),
                      SizedBox(
                        width: isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                        child: AIInsightCard(
                          title: 'Smart Recommendations',
                          description: 'Actionable study habits & break suggestions',
                          icon: Icons.lightbulb_rounded,
                          color: Colors.amber,
                          onTap: () => context.push(RouteNames.aiPlannerRecommendations),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
              // State Builder for Dynamic Highlights
              BlocBuilder<AIPlannerBloc, AIPlannerState>(
                builder: (context, state) {
                  if (state is AIPlannerLoadingState) {
                    return const AISkeletonLoader(height: 120);
                  }
                  if (state is AIPlannerLoadedState && state.productivityInsight != null) {
                    final insight = state.productivityInsight!;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 36),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Productivity Score: ${insight.productivityScore.toInt()}/100',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Best Focus Window: ${insight.bestStudyHours}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
