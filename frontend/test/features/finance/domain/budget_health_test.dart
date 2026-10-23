import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/utils/budget_health_calculator.dart';

void main() {
  group('BudgetHealthCalculator Unit Tests — PHASE FINANCE-09', () {
    test('TEST 1: 15-day elapsed pace with 30-day month', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 3000.0,
        daysInMonth: 30,
        elapsedDays: 15,
        remainingDays: 15,
      );

      expect(result.monthlyBudget, equals(15000.0));
      expect(result.spent, equals(3000.0));
      expect(result.remaining, equals(12000.0));
      expect(result.usagePercentage, equals(20.0));
      expect(result.normalDailyBudget, equals(500.0));
      expect(result.averageDailySpending, equals(200.0));
      expect(result.projectedMonthEnd, equals(6000.0));
      expect(result.safeDailyLimit, equals(800.0));
      expect(result.status, equals(BudgetHealthStatus.underBudget));
      expect(result.isUnderBudget, isTrue);
    });

    test('TEST 2: 1 day remaining edge case', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 3000.0,
        daysInMonth: 30,
        elapsedDays: 30,
        remainingDays: 1,
      );

      expect(result.remaining, equals(12000.0));
      expect(result.remainingDays, equals(1));
      expect(result.safeDailyLimit, equals(12000.0));
      expect(result.normalDailyBudget, equals(500.0));
    });

    test('TEST 3: Over-budget case preserves negative financial amount and clamps safe daily limit', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 10000.0,
        currentSpent: 12000.0,
        daysInMonth: 30,
        elapsedDays: 20,
        remainingDays: 10,
      );

      expect(result.remaining, equals(-2000.0));
      expect(result.usagePercentage, equals(120.0));
      expect(result.safeDailyLimit, equals(0.0));
      expect(result.status, equals(BudgetHealthStatus.overBudget));
      expect(result.isOverBudget, isTrue);
    });

    test('TEST 4: Zero budget handles division safely without crashing or NaN', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 0.0,
        currentSpent: 500.0,
        daysInMonth: 30,
        elapsedDays: 10,
        remainingDays: 20,
      );

      expect(result.usagePercentage, equals(0.0));
      expect(result.usagePercentage.isNaN, isFalse);
      expect(result.normalDailyBudget, equals(0.0));
      expect(result.safeDailyLimit, equals(0.0));
      expect(result.status, equals(BudgetHealthStatus.noBudget));
    });

    test('TEST 5: No expenses does not invent projected spending', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 0.0,
        daysInMonth: 30,
        elapsedDays: 10,
        remainingDays: 20,
      );

      expect(result.spent, equals(0.0));
      expect(result.remaining, equals(15000.0));
      expect(result.usagePercentage, equals(0.0));
      expect(result.averageDailySpending, isNull);
      expect(result.projectedMonthEnd, isNull);
      expect(result.normalDailyBudget, equals(500.0));
      expect(result.safeDailyLimit, equals(750.0)); // 15000 / 20 = 750
      expect(result.status, equals(BudgetHealthStatus.underBudget));
    });

    test('Calendar days determination across varying months', () {
      final sept = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 1000.0,
        currentDate: DateTime(2026, 9, 15),
      );
      expect(sept.totalDaysInMonth, equals(30));

      final oct = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 1000.0,
        currentDate: DateTime(2026, 10, 15),
      );
      expect(oct.totalDaysInMonth, equals(31));

      final febLeap = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 1000.0,
        currentDate: DateTime(2024, 2, 10),
      );
      expect(febLeap.totalDaysInMonth, equals(29));

      final febNonLeap = BudgetHealthCalculator.calculate(
        monthlyBudget: 15000.0,
        currentSpent: 1000.0,
        currentDate: DateTime(2026, 2, 10),
      );
      expect(febNonLeap.totalDaysInMonth, equals(28));
    });

    test('Approaching budget threshold (>= 80% and <= 100%)', () {
      final result = BudgetHealthCalculator.calculate(
        monthlyBudget: 10000.0,
        currentSpent: 8500.0,
        daysInMonth: 30,
        elapsedDays: 20,
        remainingDays: 10,
      );

      expect(result.usagePercentage, equals(85.0));
      expect(result.status, equals(BudgetHealthStatus.approachingBudget));
      expect(result.isApproachingBudget, isTrue);
    });
  });
}
