import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/financial_report.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import '../widgets/finance_charts.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/report_card.dart';

import '../../../../shared/widgets/base_scaffold.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedTimeframe = 'MONTHLY';

  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(LoadReportEvent(timeframe: _selectedTimeframe));
  }

  void _onTimeframeChanged(String tf) {
    setState(() => _selectedTimeframe = tf);
    context.read<ReportBloc>().add(LoadReportEvent(timeframe: tf));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Financial Analytics & Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'DAILY', label: Text('Daily')),
                ButtonSegment(value: 'WEEKLY', label: Text('Weekly')),
                ButtonSegment(value: 'MONTHLY', label: Text('Monthly')),
                ButtonSegment(value: 'YEARLY', label: Text('Yearly')),
              ],
              selected: {_selectedTimeframe},
              onSelectionChanged: (set) => _onTimeframeChanged(set.first),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF6366F1);
                  }
                  return Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E293B)
                      : Colors.grey.shade200;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87;
                }),
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.black12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoadingState) {
                  return const Column(
                    children: [
                      FinanceSkeleton(height: 140),
                      SizedBox(height: 16),
                      FinanceSkeleton(height: 220),
                    ],
                  );
                }

                if (state is ReportFailureState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Failed to load report: ${state.message}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }

                final report = (state is ReportLoadedState)
                    ? state.report
                    : FinancialReport(
                        timeframe: _selectedTimeframe,
                        totalIncome: 0.0,
                        totalExpense: 0.0,
                        netSavings: 0.0,
                        savingsRatePercentage: 0.0,
                        expenseBreakdown: const [],
                        incomeBreakdown: const [],
                        cashFlowSeries: const [],
                      );

                return Column(
                  children: [
                    ReportCard(report: report),
                    const SizedBox(height: 24),
                    FinanceCharts(report: report),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
