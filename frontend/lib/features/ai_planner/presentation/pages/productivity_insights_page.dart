import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/productivity_insight.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_skeleton_loader.dart';
import '../widgets/productivity_card.dart';
import '../widgets/trend_graph_widget.dart';

class ProductivityInsightsPage extends StatefulWidget {
  const ProductivityInsightsPage({super.key});

  @override
  State<ProductivityInsightsPage> createState() => _ProductivityInsightsPageState();
}

class _ProductivityInsightsPageState extends State<ProductivityInsightsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const LoadInsightsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productivity Insights'),
      ),
      body: BlocBuilder<AIPlannerBloc, AIPlannerState>(
        builder: (context, state) {
          if (state is AIPlannerLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: AISkeletonLoader(height: 220),
            );
          }

          final insight = (state is AIPlannerLoadedState && state.productivityInsight != null)
              ? state.productivityInsight!
              : const ProductivityInsight(
                  studyStreakDays: 7,
                  bestStudyHours: '08:00 AM - 11:00 AM',
                  focusTimeHours: 5.2,
                  completionRatePercentage: 91.0,
                  productivityScore: 94.0,
                  weeklyTrends: [60.0, 75.0, 80.0, 70.0, 92.0, 88.0, 94.0],
                  monthlyTrends: [70.0, 78.0, 85.0, 94.0],
                  keyTakeaways: [
                    'Morning focus sessions show 40% higher task completion.',
                    'Short 10-minute breaks every hour sustained peak focus.',
                  ],
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductivityCard(insight: insight),
                const SizedBox(height: 24),
                TrendGraphWidget(
                  title: 'Weekly Focus Score Trend',
                  values: insight.weeklyTrends,
                  labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                ),
                const SizedBox(height: 24),
                TrendGraphWidget(
                  title: 'Monthly Performance Curve',
                  values: insight.monthlyTrends,
                  labels: const ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                ),
                const SizedBox(height: 24),
                Text(
                  'Key AI Takeaways',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...insight.keyTakeaways.map(
                  (takeaway) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(takeaway, style: theme.textTheme.bodyMedium)),
                      ],
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
