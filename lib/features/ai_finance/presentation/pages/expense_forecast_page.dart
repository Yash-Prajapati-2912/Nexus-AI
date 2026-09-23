import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';
import '../widgets/ai_finance_charts.dart';

class ExpenseForecastPage extends StatelessWidget {
  final Forecast? forecast;

  const ExpenseForecastPage({super.key, this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = forecast ??
        const Forecast(
          nextWeekForecastAmount: 180,
          nextMonthForecastAmount: 820,
          quarterlyForecastAmount: 2450,
          yearlyForecastAmount: 9800,
          predictedMonthEndSavings: 1450,
          predictedOverspendingRisk: false,
          overspendingProbability: 0.15,
          projectedCashFlowSeries: [850, 920, 780, 1100],
          forecastExplanation: 'Statistical linear regression indicates low overspending risk for the upcoming quarter.',
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Forecast')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AIFinanceCharts(forecast: data),
            const SizedBox(height: 20),
            Text('Forecast Breakdown', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _Row(label: 'Next 7 Days Projected', value: '₹${data.nextWeekForecastAmount.toStringAsFixed(2)}'),
            _Row(label: 'Next 30 Days Projected', value: '₹${data.nextMonthForecastAmount.toStringAsFixed(2)}'),
            _Row(label: 'Quarterly Projected', value: '₹${data.quarterlyForecastAmount.toStringAsFixed(2)}'),
            _Row(label: 'Yearly Projected', value: '₹${data.yearlyForecastAmount.toStringAsFixed(2)}'),
            _Row(label: 'Predicted Month-End Savings', value: '₹${data.predictedMonthEndSavings.toStringAsFixed(2)}', color: const Color(0xFF10B981)),
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
