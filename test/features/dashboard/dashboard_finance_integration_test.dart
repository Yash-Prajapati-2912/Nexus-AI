import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/dashboard/domain/entities/chart_data_entity.dart';
import 'package:nexus_ai/features/dashboard/domain/entities/finance_summary_entity.dart';
import 'package:nexus_ai/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:nexus_ai/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:nexus_ai/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:nexus_ai/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:nexus_ai/features/dashboard/presentation/widgets/expense_chart_widget.dart';
import 'package:nexus_ai/features/dashboard/presentation/widgets/finance_summary_widget.dart';
import 'package:nexus_ai/features/finance/domain/entities/budget.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_budget_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_expenses_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_income_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_savings_goals_usecase.dart';
import 'package:nexus_ai/features/dashboard/data/models/dashboard_model.dart';
import 'package:nexus_ai/features/planner/domain/entities/task_entity.dart';
import 'package:nexus_ai/features/planner/domain/usecases/get_planner_usecase.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}
class MockGetPlannerUseCase extends Mock implements GetPlannerUseCase {}
class MockGetExpensesUseCase extends Mock implements GetExpensesUseCase {}
class MockGetIncomeUseCase extends Mock implements GetIncomeUseCase {}
class MockGetBudgetUseCase extends Mock implements GetBudgetUseCase {}
class MockGetSavingsGoalsUseCase extends Mock implements GetSavingsGoalsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const GetExpensesParams());
    registerFallbackValue(const GetIncomeParams());
  });

  late MockGetDashboardUseCase mockGetDashboardUseCase;
  late MockGetPlannerUseCase mockGetPlannerUseCase;
  late MockGetExpensesUseCase mockGetExpensesUseCase;
  late MockGetIncomeUseCase mockGetIncomeUseCase;
  late MockGetBudgetUseCase mockGetBudgetUseCase;
  late MockGetSavingsGoalsUseCase mockGetSavingsGoalsUseCase;

  setUp(() {
    mockGetDashboardUseCase = MockGetDashboardUseCase();
    mockGetPlannerUseCase = MockGetPlannerUseCase();
    mockGetExpensesUseCase = MockGetExpensesUseCase();
    mockGetIncomeUseCase = MockGetIncomeUseCase();
    mockGetBudgetUseCase = MockGetBudgetUseCase();
    mockGetSavingsGoalsUseCase = MockGetSavingsGoalsUseCase();
  });

  group('Dashboard Finance Integration - User Scenario (Income ₹26,000, Expenses ₹3,000)', () {
    final baseDashboard = DashboardModel.fromJson({}).toDomain();

    test('DashboardBloc correctly enriches with real Finance Studio transactions', () async {
      when(() => mockGetDashboardUseCase(any())).thenAnswer((_) async => Right(baseDashboard));
      when(() => mockGetPlannerUseCase(any())).thenAnswer((_) async => const Right(<TaskEntity>[]));
      when(() => mockGetExpensesUseCase(any())).thenAnswer((_) async => Right([
        Expense(
          id: 'exp-1',
          title: 'Food Bills for month',
          amount: 3000.0,
          categoryId: 'cat-food',
          categoryName: 'Food & Dining',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 10, 1),
        ),
      ]));
      when(() => mockGetIncomeUseCase(any())).thenAnswer((_) async => Right([
        Income(
          id: 'inc-1',
          title: 'Monthly Salary',
          amount: 26000.0,
          sourceCategory: 'SALARY',
          date: DateTime(2026, 10, 1),
        ),
      ]));
      when(() => mockGetBudgetUseCase(any())).thenAnswer((_) async => Right([
        Budget(
          id: 'b-1',
          name: 'Monthly Budget',
          totalLimit: 15000.0,
          currentSpent: 3000.0,
          period: 'MONTHLY',
          startDate: DateTime(2026, 10, 1),
          endDate: DateTime(2026, 10, 31),
        ),
      ]));
      when(() => mockGetSavingsGoalsUseCase(any())).thenAnswer((_) async => const Right(<SavingsGoal>[]));

      final bloc = DashboardBloc(
        getDashboardUseCase: mockGetDashboardUseCase,
        getPlannerUseCase: mockGetPlannerUseCase,
        getExpensesUseCase: mockGetExpensesUseCase,
        getIncomeUseCase: mockGetIncomeUseCase,
        getBudgetUseCase: mockGetBudgetUseCase,
        getSavingsGoalsUseCase: mockGetSavingsGoalsUseCase,
      );

      final states = <DashboardState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(LoadDashboardEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], isA<DashboardLoadingState>());
      expect(states[1], isA<DashboardLoadedState>());

      final loadedState = states[1] as DashboardLoadedState;
      final finance = loadedState.dashboard.financeSummary;

      // Assert verified prompt totals:
      expect(finance.totalIncome, 26000.0);
      expect(finance.spentThisMonth, 3000.0);
      expect(finance.netBalance, 23000.0);
      expect(finance.monthlyBudget, 15000.0);
      expect(finance.remainingBudget, 12000.0); // 15000 - 3000

      // Assert recent transactions
      expect(finance.recentTransactions.length, 2);
      expect(finance.recentTransactions.any((tx) => tx.title == 'Food Bills for month' && tx.amount == 3000.0), isTrue);

      // Assert chart data category points
      final chartPoints = loadedState.dashboard.chartData.categoryExpenses;
      expect(chartPoints.length, 1);
      expect(chartPoints.first.label, 'Food & Dining');
      expect(chartPoints.first.value, 3000.0);

      await sub.cancel();
      await bloc.close();
    });

    testWidgets('FinanceSummaryWidget displays exact scenario numbers and surplus', (tester) async {
      final summary = FinanceSummaryEntity(
        monthlyBudget: 15000.0,
        spentThisMonth: 3000.0,
        remainingBudget: 12000.0,
        todayExpenses: 0.0,
        savingsGoalProgress: 0.0,
        totalIncome: 26000.0,
        netBalance: 23000.0,
        recentTransactions: [
          FinanceTransactionEntity(
            id: 'exp-1',
            title: 'Food Bills for month',
            amount: 3000.0,
            categoryName: 'Food & Dining',
            categoryColour: '#EF4444',
            date: DateTime(2026, 10, 1),
            isExpense: true,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: FinanceSummaryWidget(summary: summary),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+₹23000'), findsOneWidget);
      expect(find.text('Surplus'), findsOneWidget);
      expect(find.text('₹26000'), findsOneWidget); // Income micro card
      expect(find.text('₹3000'), findsWidgets); // Expenses micro card and tx
      expect(find.text('Food Bills for month'), findsOneWidget);
      expect(find.text('Budget: ₹15000'), findsOneWidget);
      expect(find.text('Left: ₹12000'), findsOneWidget);
    });

    testWidgets('ExpenseChartWidget toggles between Income vs Expenses and Spending Breakdown', (tester) async {
      final chartData = [
        const ChartDataPoint(label: 'Food & Dining', value: 3000.0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: ExpenseChartWidget(
                data: chartData,
                totalIncome: 26000.0,
                totalExpenses: 3000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // By default Cash Flow tab is active:
      expect(find.text('Finance Analytics'), findsOneWidget);
      expect(find.text('Income vs. Expenses'), findsOneWidget);
      expect(find.text('+₹23000'), findsOneWidget);
      expect(find.text('Income'), findsWidgets);
      expect(find.text('Expenses'), findsWidgets);

      // Switch to Spending Breakdown tab:
      await tester.tap(find.text('Spending'));
      await tester.pumpAndSettle();

      expect(find.text('Food & Dining (₹3000)'), findsOneWidget);
      expect(find.text('Total Spent'), findsOneWidget);
      expect(find.text('₹3000'), findsWidgets);
    });

    testWidgets('ExpenseChartWidget handles empty finance datasets with clean empty state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpenseChartWidget(
              data: [],
              totalIncome: 0.0,
              totalExpenses: 0.0,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Cash Flow Activity Yet'), findsOneWidget);

      await tester.tap(find.text('Spending'));
      await tester.pumpAndSettle();

      expect(find.text('No Spending Data Yet'), findsOneWidget);
    });
  });
}
