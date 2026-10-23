import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import 'package:nexus_ai/features/finance/domain/entities/budget.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_budget_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_expenses_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_income_usecase.dart';
import 'package:nexus_ai/features/finance/domain/usecases/get_savings_goals_usecase.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_event.dart';
import 'package:nexus_ai/features/finance/presentation/bloc/finance_state.dart';

import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';

class MockGetExpensesUseCase extends Mock implements GetExpensesUseCase {}
class MockGetIncomeUseCase extends Mock implements GetIncomeUseCase {}
class MockGetBudgetUseCase extends Mock implements GetBudgetUseCase {}
class MockGetSavingsGoalsUseCase extends Mock implements GetSavingsGoalsUseCase {}
class MockIFinanceRepository extends Mock implements IFinanceRepository {}

void main() {
  late FinanceBloc financeBloc;
  late MockGetExpensesUseCase mockGetExpensesUseCase;
  late MockGetIncomeUseCase mockGetIncomeUseCase;
  late MockGetBudgetUseCase mockGetBudgetUseCase;
  late MockGetSavingsGoalsUseCase mockGetSavingsGoalsUseCase;
  late MockIFinanceRepository mockIFinanceRepository;

  setUpAll(() {
    registerFallbackValue(const GetExpensesParams());
    registerFallbackValue(const GetIncomeParams());
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockGetExpensesUseCase = MockGetExpensesUseCase();
    mockGetIncomeUseCase = MockGetIncomeUseCase();
    mockGetBudgetUseCase = MockGetBudgetUseCase();
    mockGetSavingsGoalsUseCase = MockGetSavingsGoalsUseCase();
    mockIFinanceRepository = MockIFinanceRepository();

    financeBloc = FinanceBloc(
      getExpensesUseCase: mockGetExpensesUseCase,
      getIncomeUseCase: mockGetIncomeUseCase,
      getBudgetUseCase: mockGetBudgetUseCase,
      getSavingsGoalsUseCase: mockGetSavingsGoalsUseCase,
      repository: mockIFinanceRepository,
    );
  });

  tearDown(() {
    financeBloc.close();
  });

  final tExpense = Expense(
    id: 'e1',
    title: 'Lunch',
    amount: 15.0,
    categoryId: 'c1',
    categoryName: 'Food',
    categoryIcon: 'food',
    date: DateTime(2026, 7, 26),
  );

  final tIncome = Income(
    id: 'i1',
    title: 'Salary',
    amount: 100.0,
    sourceCategory: 'SALARY',
    date: DateTime(2026, 7, 26),
  );

  final tBudget = Budget(
    id: 'b1',
    name: 'Food',
    totalLimit: 200,
    currentSpent: 15,
    period: 'MONTHLY',
    startDate: DateTime(2026, 7, 1),
    endDate: DateTime(2026, 7, 31),
  );

  final tGoal = SavingsGoal(
    id: 'sg1',
    title: 'Laptop',
    targetAmount: 1000,
    currentAmount: 200,
    targetDate: DateTime(2026, 12, 31),
  );

  test('initial state should be FinanceInitialState', () {
    expect(financeBloc.state, equals(const FinanceInitialState()));
  });

  blocTest<FinanceBloc, FinanceState>(
    'emits [FinanceLoadingState, FinanceLoadedState] when LoadFinanceDashboardEvent is added',
    build: () {
      when(() => mockGetExpensesUseCase(any())).thenAnswer((_) async => Right([tExpense]));
      when(() => mockGetIncomeUseCase(any())).thenAnswer((_) async => Right([tIncome]));
      when(() => mockGetBudgetUseCase(any())).thenAnswer((_) async => Right([tBudget]));
      when(() => mockGetSavingsGoalsUseCase(any())).thenAnswer((_) async => Right([tGoal]));
      when(() => mockIFinanceRepository.getInvestments()).thenAnswer((_) async => const Right([]));
      return financeBloc;
    },
    act: (bloc) => bloc.add(const LoadFinanceDashboardEvent()),
    expect: () => [
      const FinanceLoadingState(),
      FinanceLoadedState(
        totalBalance: 85.0,
        monthlyExpenseTotal: 15.0,
        monthlyIncomeTotal: 100.0,
        recentExpenses: [tExpense],
        recentIncomes: [tIncome],
        activeBudgets: [tBudget],
        activeGoals: [tGoal],
      ),
    ],
  );
}
