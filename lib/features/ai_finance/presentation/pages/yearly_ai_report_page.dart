import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_state.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';
import '../widgets/markdown_viewer.dart';

class YearlyAIReportPage extends StatefulWidget {
  const YearlyAIReportPage({super.key});

  @override
  State<YearlyAIReportPage> createState() => _YearlyAIReportPageState();
}

class _YearlyAIReportPageState extends State<YearlyAIReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadForecastEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yearly AI Report'),
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
        ],
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

          final currentYear = DateTime.now().year;
          final balance = financeState?.totalBalance ?? 0.0;
          final monthlySpent = financeState?.monthlyExpenseTotal ?? 0.0;
          final monthlyIncome = financeState?.monthlyIncomeTotal ?? 0.0;

          final hasData = balance != 0 || monthlySpent > 0 || monthlyIncome > 0 ||
              (state is AIFinanceLoadedState && state.forecast.yearlyForecastAmount > 0);

          if (!hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.analytics_outlined, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No Annual Data Available', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'No annual transaction records found for $currentYear. Record transactions to generate an annual AI intelligence report.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final StringBuffer sb = StringBuffer();
          sb.writeln('# Annual AI Financial Intelligence Report');
          sb.writeln('## Year $currentYear Overview');
          sb.writeln();
          sb.writeln('- **Current Net Balance**: ₹${balance.toStringAsFixed(2)}');
          if (state is AIFinanceLoadedState) {
            if (state.forecast.yearlyForecastAmount > 0) {
              sb.writeln('- **Projected Annual Outflow**: ₹${state.forecast.yearlyForecastAmount.toStringAsFixed(2)}');
            }
            if (state.health.overallScore > 0) {
              sb.writeln('- **Financial Wellness Score**: ${state.health.overallScore}/100');
            }
            sb.writeln();
            sb.writeln('## Strategic Takeaways');
            if (state.health.summaryReasoning.isNotEmpty) {
              sb.writeln('- ${state.health.summaryReasoning}');
            }
            if (state.forecast.forecastExplanation.isNotEmpty) {
              sb.writeln('- ${state.forecast.forecastExplanation}');
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
