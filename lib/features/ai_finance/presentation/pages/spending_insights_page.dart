import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/spending_insight.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';
import '../widgets/ai_insight_card.dart';

class SpendingInsightsPage extends StatefulWidget {
  final SpendingInsight? insight;

  const SpendingInsightsPage({super.key, this.insight});

  @override
  State<SpendingInsightsPage> createState() => _SpendingInsightsPageState();
}

class _SpendingInsightsPageState extends State<SpendingInsightsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.insight == null) {
      context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Spending Insights')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (widget.insight == null && state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = widget.insight ??
              (state is AIFinanceLoadedState
                  ? state.insight
                  : const SpendingInsight(
                      dailyAverageSpent: 0.0,
                      monthlyComparisonPercentage: 0.0,
                      weeklyComparisonPercentage: 0.0,
                      highestCategories: [],
                      lifestyleAnalysis: 'No spending insights available for this period.',
                      detectedAnomalies: [],
                      confidenceScore: 0.0,
                    ));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AIInsightCard(insight: data),
                const SizedBox(height: 20),
                Text('Highest Spending Categories', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (data.highestCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No categorized spending recorded for this period.',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  ...data.highestCategories.map((cat) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(cat.categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Trend: ${cat.trendDirection}'),
                          trailing: Text('₹${cat.amount.toStringAsFixed(0)} (${cat.percentage.toInt()}%)', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}
