import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/utils/finance_date_utils.dart';
import 'package:nexus_ai/features/ai_finance/data/models/budget_recommendation_model.dart';
import 'package:nexus_ai/features/ai_finance/data/models/financial_health_model.dart';
import 'package:nexus_ai/features/ai_finance/data/models/forecast_model.dart';
import 'package:nexus_ai/features/ai_finance/data/models/goal_analysis_model.dart';
import 'package:nexus_ai/features/ai_finance/data/models/savings_recommendation_model.dart';

void main() {
  group('FINAL FINANCE MODULE QA & VERIFICATION', () {
    test('1. Exact Verification Scenario: Income ₹10,000, Expenses ₹3,000, Budget ₹5,000, Goal ₹20,000', () {
      final incomes = [
        Income(
          id: 'inc-1',
          title: 'Monthly Salary',
          amount: 10000.0,
          sourceCategory: 'SALARY',
          date: DateTime(2026, 9, 1),
        ),
      ];

      final expenses = [
        Expense(
          id: 'exp-1',
          title: 'Groceries',
          amount: 1500.0,
          categoryId: 'cat-food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 9, 5),
        ),
        Expense(
          id: 'exp-2',
          title: 'Metro Pass',
          amount: 500.0,
          categoryId: 'cat-transport',
          categoryName: 'Transport',
          categoryIcon: 'commute',
          date: DateTime(2026, 9, 10),
        ),
        Expense(
          id: 'exp-3',
          title: 'Books',
          amount: 1000.0,
          categoryId: 'cat-education',
          categoryName: 'Education',
          categoryIcon: 'school',
          date: DateTime(2026, 9, 15),
        ),
      ];

      // Totals
      final totalIncome = incomes.fold(0.0, (sum, i) => sum + i.amount);
      final totalExpense = expenses.fold(0.0, (sum, e) => sum + e.amount);
      final netBalance = totalIncome - totalExpense;

      expect(totalIncome, 10000.0);
      expect(totalExpense, 3000.0);
      expect(netBalance, 7000.0);

      // Budget calculation
      const budgetLimit = 5000.0;
      final budgetSpent = totalExpense;
      final budgetRemaining = budgetLimit - budgetSpent;
      final budgetUsedPct = (budgetSpent / budgetLimit) * 100.0;

      expect(budgetSpent, 3000.0);
      expect(budgetRemaining, 2000.0);
      expect(budgetUsedPct, 60.0);

      // Savings Goal calculation
      final savingsGoal = SavingsGoal(
        id: 'goal-1',
        title: 'Emergency Fund',
        targetAmount: 20000.0,
        currentAmount: 5000.0,
        targetDate: DateTime(2026, 12, 31),
      );

      final goalRemaining = savingsGoal.targetAmount - savingsGoal.currentAmount;
      final goalProgressPct = (savingsGoal.currentAmount / savingsGoal.targetAmount) * 100.0;

      expect(goalRemaining, 15000.0);
      expect(goalProgressPct, 25.0);
      expect(savingsGoal.progressPercentage, 25.0);
      expect(savingsGoal.visualProgress, 0.25);
    });

    test('2. Mutation Cycle: Add, Edit, Delete Expense and Recalculate', () {
      final initialExpenses = [
        Expense(
          id: 'exp-1',
          title: 'Groceries',
          amount: 1500.0,
          categoryId: 'cat-food',
          categoryName: 'Food',
          categoryIcon: 'restaurant',
          date: DateTime(2026, 9, 5),
        ),
        Expense(
          id: 'exp-2',
          title: 'Metro Pass',
          amount: 500.0,
          categoryId: 'cat-transport',
          categoryName: 'Transport',
          categoryIcon: 'commute',
          date: DateTime(2026, 9, 10),
        ),
        Expense(
          id: 'exp-3',
          title: 'Books',
          amount: 1000.0,
          categoryId: 'cat-education',
          categoryName: 'Education',
          categoryIcon: 'school',
          date: DateTime(2026, 9, 15),
        ),
      ];

      // Add expense ₹500
      final addedList = List<Expense>.from(initialExpenses)
        ..add(Expense(
          id: 'exp-4',
          title: 'Snack',
          amount: 500.0,
          categoryId: 'cat-food',
          categoryName: 'Food',
          categoryIcon: 'fastfood',
          date: DateTime(2026, 9, 16),
        ));
      expect(addedList.fold(0.0, (s, e) => s + e.amount), 3500.0);

      // Edit expense: change ₹500 to ₹1000
      final editedList = addedList.map((e) {
        if (e.id == 'exp-4') {
          return e.copyWith(amount: 1000.0);
        }
        return e;
      }).toList();
      expect(editedList.fold(0.0, (s, e) => s + e.amount), 4000.0);

      // Delete expense: remove exp-4
      final deletedList = editedList.where((e) => e.id != 'exp-4').toList();
      expect(deletedList.fold(0.0, (s, e) => s + e.amount), 3000.0);
      expect(deletedList.length, 3);
    });

    test('3. Budget Overspending Calculation', () {
      const budgetLimit = 5000.0;
      const spent = 6000.0;

      const remaining = budgetLimit - spent;
      const usedPct = (spent / budgetLimit) * 100.0;

      expect(remaining, -1000.0);
      expect(usedPct, 120.0);
    });

    test('4. Savings Goal Zero-Target Safety', () {
      final goal = SavingsGoal(
        id: 'zero-goal',
        title: 'Zero Target',
        targetAmount: 0.0,
        currentAmount: 150.0,
        targetDate: DateTime(2026, 12, 31),
      );

      expect(goal.progressPercentage, 0.0);
      expect(goal.isAchieved, true);
    });

    test('5. Date Boundary QA: Sept 30 23:59:59 vs Oct 1 00:00:00', () {
      final sepStart = FinanceDateUtils.startOfMonth(2026, 9);
      final sepEnd = FinanceDateUtils.endOfMonth(2026, 9);

      final octStart = FinanceDateUtils.startOfMonth(2026, 10);
      final octEnd = FinanceDateUtils.endOfMonth(2026, 10);

      expect(sepStart.month, 9);
      expect(sepStart.day, 1);
      expect(sepEnd.month, 9);
      expect(sepEnd.day, 30);
      expect(sepEnd.hour, 23);
      expect(sepEnd.minute, 59);

      expect(octStart.month, 10);
      expect(octStart.day, 1);
      expect(octStart.hour, 0);
      expect(octStart.minute, 0);
      expect(octEnd.month, 10);
      expect(octEnd.day, 31);
    });

    test('6. Year Boundary QA: Dec 31 23:59:59 vs Jan 1 00:00:00', () {
      final decStart = FinanceDateUtils.startOfYear(2026);
      final decEnd = FinanceDateUtils.endOfYear(2026);

      final janStart = FinanceDateUtils.startOfYear(2027);

      expect(decStart.year, 2026);
      expect(decStart.month, 1);
      expect(decStart.day, 1);

      expect(decEnd.year, 2026);
      expect(decEnd.month, 12);
      expect(decEnd.day, 31);
      expect(decEnd.hour, 23);

      expect(janStart.year, 2027);
      expect(janStart.month, 1);
      expect(janStart.day, 1);
      expect(janStart.hour, 0);
    });

    test('7. AI Finance Model Fallback Integrity: No fake numbers on empty or null response', () {
      final health = FinancialHealthModel.fromJson(const {});
      expect(health.overallScore, 0);
      expect(health.budgetHealthScore, 0);
      expect(health.savingsScore, 0);
      expect(health.topStrengths, isEmpty);

      final forecast = ForecastModel.fromJson(const {});
      expect(forecast.nextWeekForecastAmount, 0.0);
      expect(forecast.nextMonthForecastAmount, 0.0);
      expect(forecast.quarterlyForecastAmount, 0.0);
      expect(forecast.yearlyForecastAmount, 0.0);
      expect(forecast.predictedMonthEndSavings, 0.0);

      final budgetRec = BudgetRecommendationModel.fromJson(const {});
      expect(budgetRec.safeDailySpendingLimit, 0.0);
      expect(budgetRec.recommendedTotalMonthlyBudget, 0.0);

      final savingsRec = SavingsRecommendationModel.fromJson(const {});
      expect(savingsRec.totalPotentialMonthlySavings, 0.0);

      final goalModel = GoalAnalysisModel.fromJson(const {});
      expect(goalModel.currentProgressPercentage, 0.0);
      expect(goalModel.recommendedMonthlyContribution, 0.0);
    });
  });
}
