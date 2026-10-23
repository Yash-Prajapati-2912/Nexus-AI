import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_state.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';
import '../widgets/markdown_viewer.dart';

class MonthlyAIReportPage extends StatefulWidget {
  const MonthlyAIReportPage({super.key});

  @override
  State<MonthlyAIReportPage> createState() => _MonthlyAIReportPageState();
}

class _MonthlyAIReportPageState extends State<MonthlyAIReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly AI Report'),
      ),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          FinanceLoadedState? financeState;
          try {
            final fState = context.read<FinanceBloc>().state;
            if (fState is FinanceLoadedState) {
              financeState = fState;
            }
          } catch (_) {}

          final income = financeState?.monthlyIncomeTotal ?? 0.0;
          final spent = financeState?.monthlyExpenseTotal ?? 0.0;
          final netSavings = income - spent;
          final savingsRate = income > 0 ? (netSavings / income * 100).clamp(0.0, 100.0) : 0.0;

          final hasTransactions = income > 0 || spent > 0;
          final hasAiData = state is AIFinanceLoadedState &&
              (state.health.overallScore > 0 || state.health.topStrengths.isNotEmpty);

          if (!hasTransactions && !hasAiData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description_outlined, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No Monthly Data Available', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'No transaction records found for this month. Add income and expense entries in the Finance module to generate an AI monthly report.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final now = DateTime.now();
          final months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          final monthName = months[now.month - 1];

          final StringBuffer sb = StringBuffer();
          sb.writeln('# Monthly AI Financial Executive Report');
          sb.writeln('## Month: $monthName ${now.year}');
          sb.writeln();
          sb.writeln('- **Total Earned**: ₹${income.toStringAsFixed(2)}');
          sb.writeln('- **Total Spent**: ₹${spent.toStringAsFixed(2)}');
          sb.writeln('- **Net Monthly Savings**: ₹${netSavings.toStringAsFixed(2)}');
          sb.writeln('- **Savings Rate**: ${savingsRate.toStringAsFixed(1)}%');
          sb.writeln();

          if (state is AIFinanceLoadedState) {
            sb.writeln('## AI Key Highlights');
            if (state.health.summaryReasoning.isNotEmpty) {
              sb.writeln('- **Assessment**: ${state.health.summaryReasoning}');
            }
            if (state.insight.highestCategories.isNotEmpty) {
              final topCat = state.insight.highestCategories.first;
              sb.writeln('- **Top Expense Category**: ${topCat.categoryName} (₹${topCat.amount.toStringAsFixed(2)})');
            }
            for (final s in state.health.topStrengths) {
              sb.writeln('- **Strength**: $s');
            }
            for (final r in state.health.keyRisks) {
              sb.writeln('- **Risk**: $r');
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: MarkdownViewer(content: sb.toString()),
          );
        },
      ),
    );
  }
}
