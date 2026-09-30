import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/financial_report.dart';
import 'package:nexus_ai/features/finance/presentation/widgets/finance_charts.dart';

void main() {
  Widget createTestWidget(FinancialReport report) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: FinanceCharts(report: report),
        ),
      ),
    );
  }

  group('FinanceCharts - Edge Cases & Chart Safety', () {
    testWidgets('1. No transactions / completely empty report: renders empty state without crashing', (tester) async {
      const emptyReport = FinancialReport(
        timeframe: 'MONTHLY',
        totalIncome: 0.0,
        totalExpense: 0.0,
        netSavings: 0.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: [],
        incomeBreakdown: [],
        cashFlowSeries: [],
        cashFlowPoints: [],
      );

      await tester.pumpWidget(createTestWidget(emptyReport));
      await tester.pumpAndSettle();

      expect(find.text('Expense Breakdown by Category'), findsOneWidget);
      expect(find.text('No expense records for this timeframe.'), findsOneWidget);
      expect(find.text('No cash flow transactions recorded for this timeframe.'), findsOneWidget);
    });

    testWidgets('2. One expense: 1 category & 1 cash flow spot rendered safely without curve crashes', (tester) async {
      const singleExpenseReport = FinancialReport(
        timeframe: 'DAILY',
        totalIncome: 0.0,
        totalExpense: 150.0,
        netSavings: -150.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: [
          CategoryBreakdownItem(
            categoryName: 'Groceries',
            amount: 150.0,
            percentage: 100.0,
            colorHex: '#EF4444',
          ),
        ],
        incomeBreakdown: [],
        cashFlowSeries: [-150.0],
        cashFlowPoints: [
          CashFlowPoint(date: '2026-09-30', inflow: 0.0, outflow: 150.0, net: -150.0),
        ],
      );

      await tester.pumpWidget(createTestWidget(singleExpenseReport));
      await tester.pumpAndSettle();

      expect(find.text('Expense Breakdown by Category'), findsOneWidget);
      expect(find.text('Total Spent'), findsOneWidget);
      expect(find.text('₹150'), findsOneWidget);
      expect(find.textContaining('Groceries ₹150.00 (100.0%)'), findsOneWidget);
      expect(find.text('Cash Flow Trend'), findsOneWidget);
      // Confirmed no exception thrown for single point
      expect(tester.takeException(), isNull);
    });

    testWidgets('3 & 4. Multiple expenses across multiple days with empty days in between', (tester) async {
      const multiDayReport = FinancialReport(
        timeframe: 'DAILY',
        totalIncome: 0.0,
        totalExpense: 300.0,
        netSavings: -300.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: [
          CategoryBreakdownItem(
            categoryName: 'Food',
            amount: 200.0,
            percentage: 66.67,
            colorHex: '#EF4444',
          ),
          CategoryBreakdownItem(
            categoryName: 'Transport',
            amount: 100.0,
            percentage: 33.33,
            colorHex: '#3B82F6',
          ),
        ],
        incomeBreakdown: [],
        cashFlowSeries: [-200.0, 0.0, -100.0],
        cashFlowPoints: [
          CashFlowPoint(date: '2026-09-28', inflow: 0.0, outflow: 200.0, net: -200.0),
          CashFlowPoint(date: '2026-09-29', inflow: 0.0, outflow: 0.0, net: 0.0), // empty day
          CashFlowPoint(date: '2026-09-30', inflow: 0.0, outflow: 100.0, net: -100.0),
        ],
      );

      await tester.pumpWidget(createTestWidget(multiDayReport));
      await tester.pumpAndSettle();

      expect(find.text('Cash Flow Trend'), findsOneWidget);
      expect(find.textContaining('Food'), findsOneWidget);
      expect(find.textContaining('Transport'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Income + expenses together: verifies dual series mapping', (tester) async {
      const dualReport = FinancialReport(
        timeframe: 'WEEKLY',
        totalIncome: 1000.0,
        totalExpense: 400.0,
        netSavings: 600.0,
        savingsRatePercentage: 60.0,
        expenseBreakdown: [
          CategoryBreakdownItem(
            categoryName: 'Shopping',
            amount: 400.0,
            percentage: 100.0,
            colorHex: '#F59E0B',
          ),
        ],
        incomeBreakdown: [
          CategoryBreakdownItem(
            categoryName: 'Salary',
            amount: 1000.0,
            percentage: 100.0,
            colorHex: '#10B981',
          ),
        ],
        cashFlowSeries: [1000.0, 0.0, -400.0],
        cashFlowPoints: [
          CashFlowPoint(date: '2026-09-28', inflow: 1000.0, outflow: 0.0, net: 1000.0),
          CashFlowPoint(date: '2026-09-29', inflow: 0.0, outflow: 0.0, net: 0.0),
          CashFlowPoint(date: '2026-09-30', inflow: 0.0, outflow: 400.0, net: -400.0),
        ],
      );

      await tester.pumpWidget(createTestWidget(dualReport));
      await tester.pumpAndSettle();

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
      expect(dualReport.incomeSeries, [1000.0, 0.0, 0.0]);
      expect(dualReport.expenseSeries, [0.0, 0.0, 400.0]);
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. Multiple expense categories: percentages sum up to 100%', (tester) async {
      const catReport = FinancialReport(
        timeframe: 'MONTHLY',
        totalIncome: 0.0,
        totalExpense: 1000.0,
        netSavings: -1000.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: [
          CategoryBreakdownItem(categoryName: 'Food', amount: 500.0, percentage: 50.0, colorHex: '#EF4444'),
          CategoryBreakdownItem(categoryName: 'Transport', amount: 300.0, percentage: 30.0, colorHex: '#3B82F6'),
          CategoryBreakdownItem(categoryName: 'Education', amount: 200.0, percentage: 20.0, colorHex: '#10B981'),
        ],
        incomeBreakdown: [],
        cashFlowSeries: [-1000.0],
        cashFlowPoints: [
          CashFlowPoint(date: '2026-09-15', inflow: 0.0, outflow: 1000.0, net: -1000.0),
        ],
      );

      await tester.pumpWidget(createTestWidget(catReport));
      await tester.pumpAndSettle();

      expect(find.textContaining('Food ₹500.00 (50.0%)'), findsOneWidget);
      expect(find.textContaining('Transport ₹300.00 (30.0%)'), findsOneWidget);
      expect(find.textContaining('Education ₹200.00 (20.0%)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('7. Weekly data crossing month boundary (e.g. Sep 28 to Oct 4)', (tester) async {
      final weeklyPoints = [
        const CashFlowPoint(date: '2026-09-28', inflow: 0.0, outflow: 50.0, net: -50.0),
        const CashFlowPoint(date: '2026-09-29', inflow: 0.0, outflow: 0.0, net: 0.0),
        const CashFlowPoint(date: '2026-09-30', inflow: 0.0, outflow: 75.0, net: -75.0),
        const CashFlowPoint(date: '2026-10-01', inflow: 0.0, outflow: 100.0, net: -100.0),
        const CashFlowPoint(date: '2026-10-02', inflow: 0.0, outflow: 0.0, net: 0.0),
        const CashFlowPoint(date: '2026-10-03', inflow: 0.0, outflow: 0.0, net: 0.0),
        const CashFlowPoint(date: '2026-10-04', inflow: 0.0, outflow: 25.0, net: -25.0),
      ];

      final weeklyReport = FinancialReport(
        timeframe: 'WEEKLY',
        totalIncome: 0.0,
        totalExpense: 250.0,
        netSavings: -250.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: const [
          CategoryBreakdownItem(categoryName: 'General', amount: 250.0, percentage: 100.0, colorHex: '#6366F1'),
        ],
        incomeBreakdown: const [],
        cashFlowSeries: weeklyPoints.map((p) => p.net).toList(),
        cashFlowPoints: weeklyPoints,
      );

      await tester.pumpWidget(createTestWidget(weeklyReport));
      await tester.pumpAndSettle();

      expect(find.text('Cash Flow Trend'), findsOneWidget);
      expect(weeklyReport.cashFlowPoints.length, 7);
      expect(tester.takeException(), isNull);
    });

    testWidgets('8 & 9. Yearly data: 12 continuous months (Jan -> Dec) with zero for empty months', (tester) async {
      final months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
      final yearlyPoints = months.map((m) {
        if (m == '09') {
          return const CashFlowPoint(date: '2026-09', inflow: 5000.0, outflow: 2000.0, net: 3000.0);
        }
        return CashFlowPoint(date: '2026-$m', inflow: 0.0, outflow: 0.0, net: 0.0);
      }).toList();

      final yearlyReport = FinancialReport(
        timeframe: 'YEARLY',
        totalIncome: 5000.0,
        totalExpense: 2000.0,
        netSavings: 3000.0,
        savingsRatePercentage: 60.0,
        expenseBreakdown: const [
          CategoryBreakdownItem(categoryName: 'Living', amount: 2000.0, percentage: 100.0, colorHex: '#10B981'),
        ],
        incomeBreakdown: const [],
        cashFlowSeries: yearlyPoints.map((p) => p.net).toList(),
        cashFlowPoints: yearlyPoints,
      );

      await tester.pumpWidget(createTestWidget(yearlyReport));
      await tester.pumpAndSettle();

      expect(find.text('Cash Flow Trend'), findsOneWidget);
      expect(yearlyReport.cashFlowPoints.length, 12);
      expect(tester.takeException(), isNull);
    });

    testWidgets('10. All-zero values safely handled without division by zero crash', (tester) async {
      final zeroPoints = List.generate(
        7,
        (i) => CashFlowPoint(date: '2026-09-2$i', inflow: 0.0, outflow: 0.0, net: 0.0),
      );

      final zeroReport = FinancialReport(
        timeframe: 'WEEKLY',
        totalIncome: 0.0,
        totalExpense: 0.0,
        netSavings: 0.0,
        savingsRatePercentage: 0.0,
        expenseBreakdown: const [],
        incomeBreakdown: const [],
        cashFlowSeries: zeroPoints.map((p) => p.net).toList(),
        cashFlowPoints: zeroPoints,
      );

      await tester.pumpWidget(createTestWidget(zeroReport));
      await tester.pumpAndSettle();

      // Zero data displays empty state for categories and cashflow
      expect(find.text('No expense records for this timeframe.'), findsOneWidget);
      expect(find.text('No cash flow transactions recorded for this timeframe.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
