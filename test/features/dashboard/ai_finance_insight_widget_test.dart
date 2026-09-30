import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/dashboard/domain/entities/finance_summary_entity.dart';
import 'package:nexus_ai/features/dashboard/presentation/widgets/ai_finance_insight_widget.dart';

Widget _buildTestWidget({
  required FinanceSummaryEntity summary,
  double width = 400,
  double height = 800,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: AiFinanceInsightWidget(summary: summary),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AiFinanceInsightWidget Tests', () {
    testWidgets('1. Empty State: displays friendly message when user has no finance data', (tester) async {
      const emptySummary = FinanceSummaryEntity(
        monthlyBudget: 0,
        spentThisMonth: 0,
        remainingBudget: 0,
        todayExpenses: 0,
        savingsGoalProgress: 0,
        totalIncome: 0,
        netBalance: 0,
        recentTransactions: [],
        aiFinancialTip: null,
      );

      await tester.pumpWidget(_buildTestWidget(summary: emptySummary));
      await tester.pumpAndSettle();

      expect(find.text('AI Finance Insight'), findsOneWidget);
      expect(
        find.text('Add some income and expense data to get personalized AI insights.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('add_finance_data_button')), findsOneWidget);
      expect(find.text('Go to Finance'), findsOneWidget);
    });

    testWidgets('2. Active State: displays real-data budget condition insight', (tester) async {
      const budgetInsight =
          'You have ₹2,000 remaining in your monthly budget. Your spending pace is on track at 60% utilization.';

      const summary = FinanceSummaryEntity(
        monthlyBudget: 5000,
        spentThisMonth: 3000,
        remainingBudget: 2000,
        todayExpenses: 150,
        savingsGoalProgress: 50,
        totalIncome: 10000,
        netBalance: 7000,
        aiFinancialTip: budgetInsight,
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('AI Finance Insight'), findsOneWidget);
      expect(find.text(budgetInsight), findsOneWidget);
      expect(find.text('LIVE INSIGHT'), findsOneWidget);
      expect(find.text('Tap to view recommendations & forecast'), findsOneWidget);
    });

    testWidgets('3. Active State: displays largest spending category insight', (tester) async {
      const categoryInsight =
          'Your Food & Dining expenses (₹4,500) are currently your largest spending category (45% of total expenses).';

      const summary = FinanceSummaryEntity(
        monthlyBudget: 12000,
        spentThisMonth: 10000,
        remainingBudget: 2000,
        todayExpenses: 300,
        savingsGoalProgress: 20,
        totalIncome: 25000,
        netBalance: 15000,
        aiFinancialTip: categoryInsight,
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      expect(find.text(categoryInsight), findsOneWidget);
      expect(find.text('AI Hub'), findsOneWidget);
    });

    testWidgets('4. Active State: displays savings goal progress insight', (tester) async {
      const savingsInsight =
          'You\'re currently saving ₹15,000 toward your active goal "MacBook Fund" (30% of ₹50,000).';

      const summary = FinanceSummaryEntity(
        monthlyBudget: 15000,
        spentThisMonth: 8000,
        remainingBudget: 7000,
        todayExpenses: 0,
        savingsGoalProgress: 30,
        totalIncome: 40000,
        netBalance: 32000,
        activeGoalTitle: 'MacBook Fund',
        activeGoalTarget: 50000,
        activeGoalCurrent: 15000,
        aiFinancialTip: savingsInsight,
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      expect(find.text(savingsInsight), findsOneWidget);
    });

    testWidgets('5. Active State: displays budget exceeded alert insight', (tester) async {
      const exceededInsight =
          'You have exceeded your monthly budget of ₹10,000 by ₹2,500. Pace remaining expenses to curb deficits.';

      const summary = FinanceSummaryEntity(
        monthlyBudget: 10000,
        spentThisMonth: 12500,
        remainingBudget: -2500,
        todayExpenses: 500,
        savingsGoalProgress: 0,
        totalIncome: 15000,
        netBalance: 2500,
        aiFinancialTip: exceededInsight,
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      expect(find.text(exceededInsight), findsOneWidget);
    });

    testWidgets('6. Error State: displays non-blocking unavailable state when data exists but tip is null', (tester) async {
      const summary = FinanceSummaryEntity(
        monthlyBudget: 10000,
        spentThisMonth: 5000,
        remainingBudget: 5000,
        todayExpenses: 100,
        savingsGoalProgress: 0,
        totalIncome: 20000,
        netBalance: 15000,
        aiFinancialTip: null, // AI generation failed/unavailable
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      expect(find.text('AI insight unavailable'), findsOneWidget);
      expect(find.byKey(const Key('retry_ai_insight_button')), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('7. Gateway Navigation: AI Hub button and card are interactable', (tester) async {
      const summary = FinanceSummaryEntity(
        monthlyBudget: 5000,
        spentThisMonth: 2000,
        remainingBudget: 3000,
        todayExpenses: 100,
        savingsGoalProgress: 20,
        totalIncome: 10000,
        netBalance: 8000,
        aiFinancialTip: 'You have ₹3,000 remaining in your monthly budget.',
      );

      await tester.pumpWidget(_buildTestWidget(summary: summary));
      await tester.pumpAndSettle();

      final aiHubButton = find.byKey(const Key('ai_finance_gateway_button'));
      expect(aiHubButton, findsOneWidget);
    });

    group('8. Responsive Screen Tests (No Overflow)', () {
      final widths = [320.0, 360.0, 375.0, 390.0, 412.0, 430.0, 1200.0];

      for (final w in widths) {
        testWidgets('renders cleanly without overflow at width ${w}px', (tester) async {
          const summary = FinanceSummaryEntity(
            monthlyBudget: 25000,
            spentThisMonth: 18500,
            remainingBudget: 6500,
            todayExpenses: 850,
            savingsGoalProgress: 65,
            totalIncome: 45000,
            netBalance: 26500,
            activeGoalTitle: 'Emergency Fund',
            activeGoalTarget: 50000,
            activeGoalCurrent: 32500,
            aiFinancialTip:
                'You have ₹6,500 remaining in your monthly budget. Your spending pace is on track at 74% utilization across your active categories.',
          );

          tester.view.physicalSize = Size(w, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(_buildTestWidget(summary: summary, width: w));
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(find.text('AI Finance Insight'), findsOneWidget);
        });
      }
    });
  });
}
