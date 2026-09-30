import 'package:flutter/material.dart';
import '../../domain/entities/financial_health.dart';
import '../widgets/finance_ai_summary.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class FinancialHealthDashboardPage extends StatefulWidget {
  final FinancialHealth? health;

  const FinancialHealthDashboardPage({super.key, this.health});

  @override
  State<FinancialHealthDashboardPage> createState() => _FinancialHealthDashboardPageState();
}

class _FinancialHealthDashboardPageState extends State<FinancialHealthDashboardPage> {
  @override
  void initState() {
    super.initState();
    if (widget.health == null) {
      context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.health != null) {
      return _buildScaffold(context, widget.health!);
    }

    return BlocBuilder<AIFinanceBloc, AIFinanceState>(
      builder: (context, state) {
        if (state is AIFinanceLoadingState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Financial Health Dashboard')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AIFinanceLoadedState) {
          return _buildScaffold(context, state.health);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Financial Health Dashboard')),
          body: const Center(child: Text('No financial health data available.')),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, FinancialHealth data) {
    final theme = Theme.of(context);
    final hasData = data.overallScore > 0 || data.topStrengths.isNotEmpty || data.keyRisks.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Health Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasData) ...[
              FinanceAISummary(health: data),
              const SizedBox(height: 20),
              Text('Health Score Breakdown', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _ScoreTile(label: 'Budget Health', score: data.budgetHealthScore),
              _ScoreTile(label: 'Savings Score', score: data.savingsScore),
              _ScoreTile(label: 'Expense Efficiency', score: data.expenseScore),
              _ScoreTile(label: 'Income Stability', score: data.incomeStabilityScore),
              _ScoreTile(label: 'Cash Flow Health', score: data.cashFlowHealthScore),
              _ScoreTile(label: 'Investment Readiness', score: data.investmentReadinessScore),
              if (data.topStrengths.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Top Financial Strengths', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...data.topStrengths.map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(s, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    )),
              ],
              if (data.keyRisks.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Key Financial Risks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...data.keyRisks.map((r) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(r, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    )),
              ],
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.health_and_safety_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No Financial Health Data', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        data.summaryReasoning.isNotEmpty
                            ? data.summaryReasoning
                            : 'No confirmed financial transactions available. Add your income, expenses, and budgets to generate health insights.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreTile({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text('$score/100', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: score / 100.0,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }
}
