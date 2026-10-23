import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/dashboard/data/models/finance_summary_model.dart';
import 'package:nexus_ai/features/dashboard/domain/entities/finance_summary_entity.dart';
import 'package:nexus_ai/features/dashboard/presentation/widgets/finance_summary_widget.dart';

void main() {
  group('FinanceSummaryModel Serialization', () {
    test('should parse backend financeOverview with activeGoal and recentTransactions', () {
      final json = {
        'monthlyBudgetPlanned': 5000,
        'totalSpentMonth': 3000,
        'remainingBudget': 2000,
        'todaysSpending': 150,
        'savingsProgressPercentage': 45.5,
        'totalIncome': 10000,
        'netBalance': 7000,
        'activeGoalTitle': 'Emergency Fund',
        'activeGoalTarget': 20000,
        'activeGoalCurrent': 7000,
        'recentTransactions': [
          {
            'id': 'tx-1',
            'title': 'Cafeteria Lunch',
            'amount': 250,
            'categoryName': 'Food',
            'categoryColour': '#10B981',
            'date': '2026-09-30T12:00:00.000Z',
            'isExpense': true,
          }
        ],
        'aiFinancialTip': null,
      };

      final model = FinanceSummaryModel.fromJson(json);
      final entity = model.toDomain();

      expect(entity.monthlyBudget, 5000.0);
      expect(entity.spentThisMonth, 3000.0);
      expect(entity.remainingBudget, 2000.0);
      expect(entity.todayExpenses, 150.0);
      expect(entity.savingsGoalProgress, 45.5);
      expect(entity.totalIncome, 10000.0);
      expect(entity.netBalance, 7000.0);
      expect(entity.activeGoalTitle, 'Emergency Fund');
      expect(entity.activeGoalTarget, 20000.0);
      expect(entity.activeGoalCurrent, 7000.0);
      expect(entity.recentTransactions.length, 1);
      expect(entity.recentTransactions.first.title, 'Cafeteria Lunch');
    });

    test('should handle empty backend financeOverview gracefully with defaults', () {
      final json = <String, dynamic>{};
      final model = FinanceSummaryModel.fromJson(json);
      final entity = model.toDomain();

      expect(entity.monthlyBudget, 0.0);
      expect(entity.spentThisMonth, 0.0);
      expect(entity.remainingBudget, 0.0);
      expect(entity.totalIncome, 0.0);
      expect(entity.netBalance, 0.0);
      expect(entity.activeGoalTitle, isNull);
      expect(entity.recentTransactions, isEmpty);
    });
  });

  group('FinanceSummaryWidget Validation Scenarios', () {
    Widget createWidgetUnderTest(FinanceSummaryEntity data, double width) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: FinanceSummaryWidget(summary: data),
              ),
            ),
          ),
        ),
      );
    }

    // Scenario 1: No Finance data (Brand new user) -> meaningful empty state
    testWidgets('Scenario 1: No Finance data shows meaningful Start Tracking empty state', (tester) async {
      const emptyData = FinanceSummaryEntity(
        monthlyBudget: 0.0,
        spentThisMonth: 0.0,
        remainingBudget: 0.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 0.0,
        totalIncome: 0.0,
        netBalance: 0.0,
      );

      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(emptyData, 360));
      await tester.pumpAndSettle();

      expect(find.text('Start Tracking Your Finances'), findsOneWidget);
      expect(find.text('Add Income'), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 2: Income only
    testWidgets('Scenario 2: Income only shows positive surplus without errors', (tester) async {
      const incomeOnly = FinanceSummaryEntity(
        monthlyBudget: 0.0,
        spentThisMonth: 0.0,
        remainingBudget: 0.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 0.0,
        totalIncome: 12000.0,
        netBalance: 12000.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(incomeOnly, 360));
      await tester.pumpAndSettle();

      expect(find.text('+₹12000'), findsOneWidget);
      expect(find.text('Surplus'), findsOneWidget);
      expect(find.text('₹12000'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget); // Expenses 0
      expect(tester.takeException(), isNull);
    });

    // Scenario 3: Expenses only
    testWidgets('Scenario 3: Expenses only shows deficit clearly', (tester) async {
      const expensesOnly = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 2500.0,
        remainingBudget: 2500.0,
        todayExpenses: 400.0,
        savingsGoalProgress: 0.0,
        totalIncome: 0.0,
        netBalance: -2500.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(expensesOnly, 360));
      await tester.pumpAndSettle();

      expect(find.text('-₹2500'), findsOneWidget);
      expect(find.text('Deficit'), findsOneWidget);
      expect(find.text('₹2500'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 4: Income + Expenses
    testWidgets('Scenario 4: Income + Expenses displays correct amounts and net balance', (tester) async {
      const balanced = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 3000.0,
        remainingBudget: 2000.0,
        todayExpenses: 450.0,
        savingsGoalProgress: 0.0,
        totalIncome: 10000.0,
        netBalance: 7000.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(balanced, 360));
      await tester.pumpAndSettle();

      expect(find.text('+₹7000'), findsOneWidget);
      expect(find.text('₹10000'), findsOneWidget);
      expect(find.text('₹3000'), findsOneWidget);
      expect(find.text('Surplus'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 5: Active savings goal
    testWidgets('Scenario 5: Active savings goal displays goal name and progress', (tester) async {
      const withGoal = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 2000.0,
        remainingBudget: 3000.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 35.0,
        totalIncome: 8000.0,
        netBalance: 6000.0,
        activeGoalTitle: 'Emergency Fund',
        activeGoalTarget: 20000.0,
        activeGoalCurrent: 7000.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(withGoal, 360));
      await tester.pumpAndSettle();

      expect(find.text('Emergency Fund'), findsOneWidget);
      expect(find.text('₹7000 saved'), findsOneWidget);
      expect(find.text('Goal: ₹20000'), findsOneWidget);
      expect(find.text('35%'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 6: No savings goal
    testWidgets('Scenario 6: No savings goal displays clean empty tile with Create Goal action', (tester) async {
      const noGoal = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 2000.0,
        remainingBudget: 3000.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 0.0,
        totalIncome: 8000.0,
        netBalance: 6000.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(noGoal, 360));
      await tester.pumpAndSettle();

      expect(find.text('No savings goal yet'), findsOneWidget);
      expect(find.text('Create Goal'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 7: Under-budget state
    testWidgets('Scenario 7: Under-budget state shows usage and remaining amount', (tester) async {
      const underBudget = FinanceSummaryEntity(
        monthlyBudget: 10000.0,
        spentThisMonth: 6000.0,
        remainingBudget: 4000.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 0.0,
        totalIncome: 12000.0,
        netBalance: 6000.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(underBudget, 360));
      await tester.pumpAndSettle();

      expect(find.text('60% Used'), findsOneWidget);
      expect(find.text('Budget: ₹10000'), findsOneWidget);
      expect(find.text('Spent: ₹6000'), findsOneWidget);
      expect(find.text('Left: ₹4000'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 8: Over-budget state
    testWidgets('Scenario 8: Over-budget state highlights overage cleanly', (tester) async {
      const overBudget = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 6500.0,
        remainingBudget: -1500.0,
        todayExpenses: 500.0,
        savingsGoalProgress: 0.0,
        totalIncome: 8000.0,
        netBalance: 1500.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(overBudget, 360));
      await tester.pumpAndSettle();

      expect(find.text('130% (Over)'), findsOneWidget);
      expect(find.text('Over: ₹1500'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Scenario 9: Long transaction and category names
    testWidgets('Scenario 9: Long transaction and category names do not overflow', (tester) async {
      final longData = FinanceSummaryEntity(
        monthlyBudget: 5000.0,
        spentThisMonth: 3000.0,
        remainingBudget: 2000.0,
        todayExpenses: 450.0,
        savingsGoalProgress: 50.0,
        totalIncome: 10000.0,
        netBalance: 7000.0,
        activeGoalTitle: 'Extremely Long Goal Title For Advanced Academic Scholarship Savings',
        activeGoalTarget: 50000.0,
        activeGoalCurrent: 25000.0,
        recentTransactions: [
          FinanceTransactionEntity(
            id: '1',
            title: 'Very Long Grocery Receipt From Organic Natural Supermarket Store',
            amount: 2450.0,
            categoryName: 'Extraordinary Food & Groceries Category',
            categoryColour: '#F59E0B',
            date: DateTime.now(),
            isExpense: true,
          ),
        ],
      );

      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(longData, 320));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // Scenario 10: Negative balance (Deficit)
    testWidgets('Scenario 10: Negative balance displays Deficit badge and formatted negative amount', (tester) async {
      const negativeBalance = FinanceSummaryEntity(
        monthlyBudget: 4000.0,
        spentThisMonth: 5200.0,
        remainingBudget: -1200.0,
        todayExpenses: 300.0,
        savingsGoalProgress: 0.0,
        totalIncome: 4000.0,
        netBalance: -1200.0,
      );

      await tester.pumpWidget(createWidgetUnderTest(negativeBalance, 360));
      await tester.pumpAndSettle();

      expect(find.text('-₹1200'), findsOneWidget);
      expect(find.text('Deficit'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // Responsive widths tests: 320px, 360px, 375px, 390px, 412px, 430px, 1200px
    final testWidths = [320.0, 360.0, 375.0, 390.0, 412.0, 430.0, 1200.0];

    final standardSummary = FinanceSummaryEntity(
      monthlyBudget: 5000.0,
      spentThisMonth: 3000.0,
      remainingBudget: 2000.0,
      todayExpenses: 450.0,
      savingsGoalProgress: 50.0,
      totalIncome: 10000.0,
      netBalance: 7000.0,
      activeGoalTitle: 'Emergency Fund',
      activeGoalTarget: 20000.0,
      activeGoalCurrent: 10000.0,
      recentTransactions: [
        FinanceTransactionEntity(
          id: '1',
          title: 'Campus Bookstore',
          amount: 850.0,
          categoryName: 'Academics',
          categoryColour: '#6366F1',
          date: DateTime(2026, 9, 30),
          isExpense: true,
        ),
      ],
    );

    for (final width in testWidths) {
      testWidgets('Responsive width ${width}px renders cleanly with zero overflow', (tester) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createWidgetUnderTest(standardSummary, width));
        await tester.pumpAndSettle();

        expect(find.text('Finance Overview'), findsOneWidget);
        expect(find.text('+₹7000'), findsOneWidget);
        expect(find.text('₹10000'), findsOneWidget);
        expect(find.text('₹3000'), findsOneWidget);
        expect(find.text('Campus Bookstore'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
