import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/financial_report.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import '../widgets/finance_charts.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/report_card.dart';

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
    return Scaffold(
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

                final report = (state is ReportLoadedState)
                    ? state.report
                    : const FinancialReport(
                        timeframe: 'MONTHLY',
                        totalIncome: 3250.00,
                        totalExpense: 1420.50,
                        netSavings: 1829.50,
                        savingsRatePercentage: 56.3,
                        expenseBreakdown: [
                          CategoryBreakdownItem(categoryName: 'Education', amount: 500, percentage: 35, colorHex: '#3B82F6'),
                          CategoryBreakdownItem(categoryName: 'Food & Dining', amount: 420, percentage: 30, colorHex: '#EF4444'),
                          CategoryBreakdownItem(categoryName: 'Transportation', amount: 250, percentage: 18, colorHex: '#F59E0B'),
                          CategoryBreakdownItem(categoryName: 'Shopping', amount: 250.5, percentage: 17, colorHex: '#EC4899'),
                        ],
                        incomeBreakdown: [
                          CategoryBreakdownItem(categoryName: 'Salary', amount: 2500, percentage: 77, colorHex: '#10B981'),
                          CategoryBreakdownItem(categoryName: 'Scholarship', amount: 750, percentage: 23, colorHex: '#8B5CF6'),
                        ],
                        cashFlowSeries: [1100, 850, 1600, 950, 1829.5],
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
