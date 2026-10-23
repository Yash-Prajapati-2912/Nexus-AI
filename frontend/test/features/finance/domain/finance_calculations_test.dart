import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/budget.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';

void main() {
  group('Finance Calculations Core Verification', () {
    test('TEST 1: Income = 3000, Expense = 300 -> Net = 2700', () {
      final incomes = [
        Income(
          id: 'inc1',
          title: 'Freelance payment',
          amount: 3000.0,
          sourceCategory: 'SALARY',
          date: DateTime(2026, 3, 1),
        ),
      ];
      final expenses = [
        Expense(
          id: 'exp1',
          title: 'Grocery',
          amount: 300.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 3, 5),
        ),
      ];

      final totalIncome = incomes.fold(0.0, (s, i) => s + i.amount);
      final totalExpense = expenses.fold(0.0, (s, e) => s + e.amount);
      final netBalance = totalIncome - totalExpense;

      expect(totalIncome, equals(3000.0));
      expect(totalExpense, equals(300.0));
      expect(netBalance, equals(2700.0));
    });

    test('TEST 2: Add 700 expense -> Total Expense = 1000, Net = 2000', () {
      final incomes = [
        Income(
          id: 'inc1',
          title: 'Freelance payment',
          amount: 3000.0,
          sourceCategory: 'SALARY',
          date: DateTime(2026, 3, 1),
        ),
      ];
      final expenses = [
        Expense(
          id: 'exp1',
          title: 'Grocery',
          amount: 300.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 3, 5),
        ),
        Expense(
          id: 'exp2',
          title: 'Electricity bill',
          amount: 700.0,
          categoryId: 'bills',
          categoryName: 'Bills',
          categoryIcon: 'bolt',
          date: DateTime(2026, 3, 10),
        ),
      ];

      final totalIncome = incomes.fold(0.0, (s, i) => s + i.amount);
      final totalExpense = expenses.fold(0.0, (s, e) => s + e.amount);
      final netBalance = totalIncome - totalExpense;

      expect(totalExpense, equals(1000.0));
      expect(netBalance, equals(2000.0));
    });

    test('TEST 3: Delete 700 expense -> Total Expense = 300, Net = 2700', () {
      final incomes = [
        Income(
          id: 'inc1',
          title: 'Freelance payment',
          amount: 3000.0,
          sourceCategory: 'SALARY',
          date: DateTime(2026, 3, 1),
        ),
      ];
      final expenses = [
        Expense(
          id: 'exp1',
          title: 'Grocery',
          amount: 300.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 3, 5),
        ),
        Expense(
          id: 'exp2',
          title: 'Electricity bill',
          amount: 700.0,
          categoryId: 'bills',
          categoryName: 'Bills',
          categoryIcon: 'bolt',
          date: DateTime(2026, 3, 10),
        ),
      ];

      // Remove exp2 (simulate delete)
      final remainingExpenses = expenses.where((e) => e.id != 'exp2').toList();

      final totalIncome = incomes.fold(0.0, (s, i) => s + i.amount);
      final totalExpense = remainingExpenses.fold(0.0, (s, e) => s + e.amount);
      final netBalance = totalIncome - totalExpense;

      expect(totalExpense, equals(300.0));
      expect(netBalance, equals(2700.0));
    });

    test('TEST 4: Budget = 2000, Applicable expenses = 1000 -> Spent = 1000, Remaining = 1000, Used = 50%', () {
      final budget = Budget(
        id: 'b1',
        name: 'Monthly Discretionary',
        totalLimit: 2000.0,
        currentSpent: 1000.0,
        period: 'MONTHLY',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
      );

      expect(budget.currentSpent, equals(1000.0));
      expect(budget.remainingAmount, equals(1000.0));
      expect(budget.usedPercentage, equals(50.0));
      expect(budget.visualProgress, equals(0.5));
      expect(budget.isOverBudget, isFalse);
    });

    test('TEST 4b: Budget = 5000, Spent = 5500 -> Spent = 5500, Remaining = -500, Used = 110%', () {
      final budget = Budget(
        id: 'b2',
        name: 'Dining Budget',
        totalLimit: 5000.0,
        currentSpent: 5500.0,
        period: 'MONTHLY',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
      );

      expect(budget.currentSpent, equals(5500.0));
      expect(budget.remainingAmount, equals(-500.0));
      expect(budget.usedPercentage, closeTo(110.0, 0.001));
      expect(budget.visualProgress, equals(1.0)); // Clamped for visual progress bar
      expect(budget.isOverBudget, isTrue);
    });

    test('TEST 5: Savings target = 10000, Current = 4000 -> Remaining = 6000, Progress = 40%', () {
      final goal = SavingsGoal(
        id: 'sg1',
        title: 'Emergency Fund',
        targetAmount: 10000.0,
        currentAmount: 4000.0,
        targetDate: DateTime(2026, 12, 31),
      );

      expect(goal.remainingAmount, equals(6000.0));
      expect(goal.progressPercentage, equals(40.0));
      expect(goal.visualProgress, equals(0.4));
      expect(goal.isAchieved, isFalse);
    });

    test('Safe zero division: Budget planned = 0, Savings target = 0', () {
      final zeroBudget = Budget(
        id: 'b0',
        name: 'Zero Budget',
        totalLimit: 0.0,
        currentSpent: 100.0,
        period: 'MONTHLY',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
      );

      expect(zeroBudget.usedPercentage, equals(0.0));
      expect(zeroBudget.visualProgress, equals(0.0));
      expect(zeroBudget.remainingAmount, equals(-100.0));

      final zeroGoal = SavingsGoal(
        id: 'sg0',
        title: 'Zero Target Goal',
        targetAmount: 0.0,
        currentAmount: 100.0,
        targetDate: DateTime(2026, 12, 31),
      );

      expect(zeroGoal.progressPercentage, equals(0.0));
      expect(zeroGoal.visualProgress, equals(0.0));
    });

    test('Strict period filtering: transactions outside start and end are excluded', () {
      final budget = Budget(
        id: 'b_march',
        name: 'March Budget',
        totalLimit: 5000.0,
        currentSpent: 0.0,
        period: 'MONTHLY',
        startDate: DateTime(2026, 3, 1),
        endDate: DateTime(2026, 3, 31),
      );

      final expenses = [
        Expense(
          id: 'exp_feb',
          title: 'Late Feb Expense',
          amount: 250.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 2, 28, 23, 59),
        ),
        Expense(
          id: 'exp_mar1',
          title: 'March 1 Expense',
          amount: 500.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 3, 1, 0, 1),
        ),
        Expense(
          id: 'exp_mar31',
          title: 'March 31 Expense',
          amount: 500.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 3, 31, 23, 30),
        ),
        Expense(
          id: 'exp_apr1',
          title: 'April 1 Expense',
          amount: 400.0,
          categoryId: 'food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 4, 1, 0, 5),
        ),
      ];

      final start = DateTime(budget.startDate.year, budget.startDate.month, budget.startDate.day, 0, 0, 0);
      final end = DateTime(budget.endDate.year, budget.endDate.month, budget.endDate.day, 23, 59, 59, 999);

      final applicableExpenses = expenses.where((e) {
        return !e.date.isBefore(start) && !e.date.isAfter(end);
      }).toList();

      final spentInPeriod = applicableExpenses.fold(0.0, (sum, e) => sum + e.amount);

      expect(applicableExpenses.length, equals(2));
      expect(spentInPeriod, equals(1000.0));
      expect(budget.copyWith(currentSpent: spentInPeriod).remainingAmount, equals(4000.0));
    });
  });
}
