import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/budget_recommendation.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class BudgetRecommendationsPage extends StatefulWidget {
  final BudgetRecommendation? recommendation;

  const BudgetRecommendationsPage({super.key, this.recommendation});

  @override
  State<BudgetRecommendationsPage> createState() => _BudgetRecommendationsPageState();
}

class _BudgetRecommendationsPageState extends State<BudgetRecommendationsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.recommendation == null) {
      context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Recommendations')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (widget.recommendation == null && state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = widget.recommendation ??
              (state is AIFinanceLoadedState
                  ? state.budgetRec
                  : const BudgetRecommendation(
                      safeDailySpendingLimit: 0.0,
                      recommendedTotalMonthlyBudget: 0.0,
                      categoryAdjustments: [],
                      optimizationStrategy: 'No budget recommendations available.',
                    ));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: theme.colorScheme.primaryContainer.withAlpha(80),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Recommended Safe Daily Limit', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 4),
                        Text(
                          '₹${data.safeDailySpendingLimit.toStringAsFixed(2)}/day',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (data.optimizationStrategy.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            data.optimizationStrategy,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Category Optimizations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (data.categoryAdjustments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No category budget adjustments needed at this time.',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  ...data.categoryAdjustments.map((adj) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(adj.categoryName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'Current: ₹${adj.currentLimit.toStringAsFixed(0)} ➔ Recommended: ₹${adj.recommendedLimit.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                              ),
                              const SizedBox(height: 4),
                              Text(adj.reasoning, style: theme.textTheme.bodySmall),
                            ],
                          ),
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
