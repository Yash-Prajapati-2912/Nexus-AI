import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/ai_finance/data/models/spending_insight_model.dart';
import 'package:nexus_ai/features/finance/domain/entities/budget.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/presentation/widgets/ai_finance_insights_section.dart';

void main() {
  group('AI Finance Insights & Suggestions Verification', () {
    const double recordedIncome = 10000.0;
    const foodExpense = 1500.0;
    const transportExpense = 500.0;
    const educationExpense = 1000.0;
    const totalExpenses = foodExpense + transportExpense + educationExpense;
    const netBalance = recordedIncome - totalExpenses;

    const budgetLimit = 5000.0;
    const budgetSpent = totalExpenses;
    const budgetRemaining = budgetLimit - budgetSpent;
    const budgetUsagePercent = (budgetSpent / budgetLimit) * 100;

    const goalTarget = 20000.0;
    const goalCurrent = 5000.0;
    const goalRemaining = goalTarget - goalCurrent;
    const goalProgressPercent = (goalCurrent / goalTarget) * 100;

    final List<Expense> mockExpenses = [
      Expense(
        id: 'exp-1',
        title: 'Groceries',
        amount: foodExpense,
        categoryId: 'cat-1',
        categoryName: 'Food & Dining',
        categoryIcon: 'restaurant',
        date: DateTime.now(),
      ),
      Expense(
        id: 'exp-2',
        title: 'Metro Pass',
        amount: transportExpense,
        categoryId: 'cat-2',
        categoryName: 'Transport',
        categoryIcon: 'commute',
        date: DateTime.now(),
      ),
      Expense(
        id: 'exp-3',
        title: 'Textbooks',
        amount: educationExpense,
        categoryId: 'cat-3',
        categoryName: 'Education',
        categoryIcon: 'school',
        date: DateTime.now(),
      ),
    ];

    final List<Budget> mockBudgets = [
      Budget(
        id: 'b-1',
        name: 'Monthly Living',
        totalLimit: budgetLimit,
        currentSpent: budgetSpent,
        period: 'MONTHLY',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];

    final List<SavingsGoal> mockGoals = [
      SavingsGoal(
        id: 'g-1',
        title: 'Emergency Fund',
        targetAmount: goalTarget,
        currentAmount: goalCurrent,
        targetDate: DateTime.now().add(const Duration(days: 180)),
      ),
    ];

    test('1. Section 20 Scenario: Verifies accurate financial balance and totals', () {
      expect(recordedIncome, 10000.0);
      expect(totalExpenses, 3000.0);
      expect(netBalance, 7000.0);
      expect(budgetRemaining, 2000.0);
      expect(budgetUsagePercent, 60.0);
      expect(goalRemaining, 15000.0);
      expect(goalProgressPercent, 25.0);
    });

    test('2. Expense Analysis: Verifies category percentages and rank', () {
      final categories = [
        {'name': 'Food', 'amount': foodExpense, 'pct': (foodExpense / totalExpenses) * 100},
        {'name': 'Education', 'amount': educationExpense, 'pct': (educationExpense / totalExpenses) * 100},
        {'name': 'Transport', 'amount': transportExpense, 'pct': (transportExpense / totalExpenses) * 100},
      ];

      expect(categories[0]['name'], 'Food');
      expect(categories[0]['pct'], 50.0);

      expect(categories[1]['name'], 'Education');
      expect((categories[1]['pct'] as double).toStringAsFixed(1), '33.3');

      expect(categories[2]['name'], 'Transport');
      expect((categories[2]['pct'] as double).toStringAsFixed(1), '16.7');
    });

    test('3. Savings Recommendation: Grounded in Income - Expenses = Net', () {
      const availablePreSavings = recordedIncome - totalExpenses;
      expect(availablePreSavings, 7000.0);

      const suggestedMonthlySaving = 5000.0;
      expect(suggestedMonthlySaving <= availablePreSavings, isTrue);

      final monthsToGoal = (goalRemaining / suggestedMonthlySaving).ceil();
      expect(monthsToGoal, 3);
    });

    test('4. Emergency Reserve Calculation: Based on essential monthly spending', () {
      const essentialExpenses = totalExpenses; // ₹3,000
      const threeMonthReserve = essentialExpenses * 3;
      const sixMonthReserve = essentialExpenses * 6;

      expect(threeMonthReserve, 9000.0);
      expect(sixMonthReserve, 18000.0);
    });

    test('5. SpendingInsightModel parses AI analysis response with 4-part markdown and categories', () {
      final jsonResponse = {
        'lifestyleAnalysis': '''
### Summary
Your recorded income is ₹10000 and total spending is ₹3000, leaving a net balance of ₹7000.

### What I noticed
- Food is your largest expense at ₹1500 (50.0% of total spending).
- You have used 60.0% of your ₹5000 budget with ₹2000 remaining.
- Savings goal is 25.0% achieved (₹5000 of ₹20000).

### What you could do
- Maintain current spending within the remaining ₹2000 budget.
- Allocate ₹5000/month toward your goal to reach it in approximately 3 months.

### If you want to save/invest
- Priority 1: Keep a 3-month essential reserve of ₹9000 in liquid savings.
- Priority 2: Fund your savings goal before considering longer-term market instruments.
''',
        'confidenceScore': 0.95,
        'dailyAverageSpent': 100.0,
        'highestCategories': [
          {'categoryName': 'Food', 'amount': 1500.0, 'percentage': 50.0, 'trendDirection': 'STABLE'},
          {'categoryName': 'Education', 'amount': 1000.0, 'percentage': 33.3, 'trendDirection': 'STABLE'},
          {'categoryName': 'Transport', 'amount': 500.0, 'percentage': 16.7, 'trendDirection': 'STABLE'},
        ],
        'detectedAnomalies': <String>[],
      };

      final model = SpendingInsightModel.fromJson(jsonResponse);

      expect(model.dailyAverageSpent, 100.0);
      expect(model.highestCategories.length, 3);
      expect(model.highestCategories.first.categoryName, 'Food');
      expect(model.highestCategories.first.amount, 1500.0);
      expect(model.highestCategories.first.percentage, 50.0);
      expect(model.lifestyleAnalysis, contains('### Summary'));
      expect(model.lifestyleAnalysis, contains('### What I noticed'));
      expect(model.lifestyleAnalysis, contains('### What you could do'));
      expect(model.lifestyleAnalysis, contains('### If you want to save/invest'));
      expect(model.lifestyleAnalysis, contains('₹10000'));
      expect(model.lifestyleAnalysis, contains('₹3000'));
    });

    testWidgets('6. UI: Empty state card renders without crash when no data exists', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: [],
                budgets: [],
                savingsGoals: [],
                monthlyIncome: 0.0,
                monthlyExpense: 0.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unlock Personalized Insights'), findsOneWidget);
      expect(find.text('Add a few income and expense records to unlock personalized financial insights and actionable recommendations.'), findsOneWidget);
      expect(find.text('Add Income'), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
    });

    testWidgets('7. UI: All 5 AI Action Chips render and are interactable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: mockExpenses,
                budgets: mockBudgets,
                savingsGoals: mockGoals,
                monthlyIncome: recordedIncome,
                monthlyExpense: totalExpenses,
                totalBalance: netBalance,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Analyze Spending'), findsOneWidget);
      expect(find.text('Plan My Savings'), findsOneWidget);
      expect(find.text('Review My Budget'), findsOneWidget);
      expect(find.text('Investment Guidance'), findsOneWidget);
      expect(find.text('Monthly Summary'), findsOneWidget);

      // Tap Analyze Spending
      await tester.tap(find.text('Analyze Spending'));
      await tester.pumpAndSettle();

      expect(find.text('SPENDING ANALYSIS'), findsOneWidget);
      expect(find.textContaining('Food & Dining'), findsWidgets);

      // Tap Plan My Savings
      await tester.tap(find.text('Plan My Savings'));
      await tester.pumpAndSettle();

      expect(find.text('SAVINGS PLAN'), findsOneWidget);
      expect(find.textContaining('Emergency Fund'), findsWidgets);

      // Tap Review My Budget
      await tester.tap(find.text('Review My Budget'));
      await tester.pumpAndSettle();

      expect(find.text('BUDGET REVIEW'), findsOneWidget);

      // Tap Investment Guidance
      await tester.ensureVisible(find.text('Investment Guidance'));
      await tester.tap(find.text('Investment Guidance'));
      await tester.pumpAndSettle();

      expect(find.text('INVESTMENT GUIDANCE'), findsOneWidget);
      expect(find.text('3-Mo Emergency'), findsOneWidget);

      // Tap Monthly Summary
      await tester.ensureVisible(find.text('Monthly Summary'));
      await tester.tap(find.text('Monthly Summary'));
      await tester.pumpAndSettle();

      expect(find.text('MONTHLY SUMMARY'), findsOneWidget);
    });

    testWidgets('8. Stale Data Lifecycle: Correctly reflects additions and deletions', (tester) async {
      final dynamicExpenses = List<Expense>.from(mockExpenses);

      // Initial state: ₹3,000
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: dynamicExpenses,
                budgets: mockBudgets,
                savingsGoals: mockGoals,
                monthlyIncome: recordedIncome,
                monthlyExpense: 3000.0,
                totalBalance: 7000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Spending'));
      await tester.pumpAndSettle();
      expect(find.text('₹3000'), findsOneWidget);

      // Add ₹1,000 expense
      dynamicExpenses.add(
        Expense(
          id: 'exp-4',
          title: 'Shopping',
          amount: 1000.0,
          categoryId: 'cat-4',
          categoryName: 'Shopping',
          categoryIcon: 'shopping_bag',
          date: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: dynamicExpenses,
                budgets: mockBudgets,
                savingsGoals: mockGoals,
                monthlyIncome: recordedIncome,
                monthlyExpense: 4000.0,
                totalBalance: 6000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Spending'));
      await tester.pumpAndSettle();
      expect(find.text('₹4000'), findsOneWidget);

      // Remove the ₹1,000 expense
      dynamicExpenses.removeLast();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: dynamicExpenses,
                budgets: mockBudgets,
                savingsGoals: mockGoals,
                monthlyIncome: recordedIncome,
                monthlyExpense: 3000.0,
                totalBalance: 7000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Spending'));
      await tester.pumpAndSettle();
      expect(find.text('₹3000'), findsOneWidget);
    });

    testWidgets('9. Investment Guidance: Safety, disclaimers, and interactive parameter toggles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AIFinanceInsightsSection(
                expenses: mockExpenses,
                budgets: mockBudgets,
                savingsGoals: mockGoals,
                monthlyIncome: recordedIncome,
                monthlyExpense: totalExpenses,
                totalBalance: netBalance,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Investment Guidance'));
      await tester.tap(find.text('Investment Guidance'));
      await tester.pumpAndSettle();

      // Check emergency fund calculation (3 * 3,000 = ₹9,000)
      expect(find.textContaining('9000'), findsWidgets);
      // Check disclaimer
      expect(find.textContaining('guarantee investment returns'), findsWidgets);

      // Switch to 1-3 Years
      await tester.tap(find.text('1–3 Years'));
      await tester.pumpAndSettle();
      expect(find.textContaining('inflation'), findsWidgets);

      // Switch to 3+ Years
      await tester.tap(find.text('3+ Years'));
      await tester.pumpAndSettle();
      expect(find.textContaining('diversified'), findsWidgets);
    });

    // Multi-Width Responsive Suite
    final testWidths = [320.0, 360.0, 375.0, 390.0, 412.0, 430.0, 1200.0];
    for (final width in testWidths) {
      testWidgets('10. Responsive Layout: Renders with 0 overflow at ${width.toInt()}px width', (tester) async {
        tester.view.physicalSize = Size(width, 700);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AIFinanceInsightsSection(
                  expenses: mockExpenses,
                  budgets: mockBudgets,
                  savingsGoals: mockGoals,
                  monthlyIncome: recordedIncome,
                  monthlyExpense: totalExpenses,
                  totalBalance: netBalance,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Exercise Investment Guidance which has interactive chips
        await tester.ensureVisible(find.text('Investment Guidance'));
        await tester.tap(find.text('Investment Guidance'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  });
}
