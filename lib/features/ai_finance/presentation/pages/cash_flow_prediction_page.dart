import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class CashFlowPredictionPage extends StatefulWidget {
  const CashFlowPredictionPage({super.key});

  @override
  State<CashFlowPredictionPage> createState() => _CashFlowPredictionPageState();
}

class _CashFlowPredictionPageState extends State<CashFlowPredictionPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadForecastEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Flow Prediction')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AIFinanceLoadedState) {
            final f = state.forecast;
            final hasData = f.nextMonthForecastAmount > 0 || f.predictedMonthEndSavings != 0 || f.quarterlyForecastAmount > 0;

            if (!hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('Insufficient Cash Flow Data', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        f.forecastExplanation.isNotEmpty
                            ? f.forecastExplanation
                            : 'Add recurring income and expenses to view projected cash flow and month-end balance forecasts.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projected Cash Flow (30 to 90-Day Horizon)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _RowItem(
                            label: 'Next 30 Days Outflow',
                            value: '₹${f.nextMonthForecastAmount.toStringAsFixed(2)}',
                            color: Colors.redAccent,
                          ),
                          const Divider(),
                          _RowItem(
                            label: 'Quarterly Outflow',
                            value: '₹${f.quarterlyForecastAmount.toStringAsFixed(2)}',
                            color: Colors.orangeAccent,
                          ),
                          const Divider(),
                          _RowItem(
                            label: 'Predicted Month-End Savings',
                            value: '₹${f.predictedMonthEndSavings.toStringAsFixed(2)}',
                            color: f.predictedMonthEndSavings >= 0 ? const Color(0xFF10B981) : Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (f.forecastExplanation.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(f.forecastExplanation, style: theme.textTheme.bodyMedium),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return const Center(child: Text('No cash flow prediction data available.'));
        },
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RowItem({required this.label, required this.value, required this.color});

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
