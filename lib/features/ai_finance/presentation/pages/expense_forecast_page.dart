import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';
import '../widgets/ai_finance_charts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class ExpenseForecastPage extends StatefulWidget {
  final Forecast? forecast;

  const ExpenseForecastPage({super.key, this.forecast});

  @override
  State<ExpenseForecastPage> createState() => _ExpenseForecastPageState();
}

class _ExpenseForecastPageState extends State<ExpenseForecastPage> {
  @override
  void initState() {
    super.initState();
    if (widget.forecast == null) {
      context.read<AIFinanceBloc>().add(const LoadForecastEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.forecast != null) {
      return _buildScaffold(context, widget.forecast!);
    }

    return BlocBuilder<AIFinanceBloc, AIFinanceState>(
      builder: (context, state) {
        if (state is AIFinanceLoadingState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Expense Forecast')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AIFinanceLoadedState) {
          return _buildScaffold(context, state.forecast);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Expense Forecast')),
          body: const Center(child: Text('No forecast data available.')),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Forecast data) {
    final theme = Theme.of(context);
    final hasData = data.nextMonthForecastAmount > 0 ||
        data.nextWeekForecastAmount > 0 ||
        data.quarterlyForecastAmount > 0 ||
        data.predictedMonthEndSavings != 0 ||
        data.projectedCashFlowSeries.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Forecast')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasData) ...[
              AIFinanceCharts(forecast: data),
              const SizedBox(height: 20),
              Text('Forecast Breakdown', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _Row(label: 'Next 7 Days Projected', value: '₹${data.nextWeekForecastAmount.toStringAsFixed(2)}'),
              _Row(label: 'Next 30 Days Projected', value: '₹${data.nextMonthForecastAmount.toStringAsFixed(2)}'),
              _Row(label: 'Quarterly Projected', value: '₹${data.quarterlyForecastAmount.toStringAsFixed(2)}'),
              _Row(label: 'Yearly Projected', value: '₹${data.yearlyForecastAmount.toStringAsFixed(2)}'),
              _Row(label: 'Predicted Month-End Savings', value: '₹${data.predictedMonthEndSavings.toStringAsFixed(2)}', color: const Color(0xFF10B981)),
              if (data.forecastExplanation.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(data.forecastExplanation, style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.trending_up_rounded, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('Insufficient Expense Data', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        data.forecastExplanation.isNotEmpty
                            ? data.forecastExplanation
                            : 'No expense records found. Add transactions to generate spending forecasts and overspending risk projections.',
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

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Row({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
