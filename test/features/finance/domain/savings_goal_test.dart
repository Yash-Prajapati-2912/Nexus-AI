import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';

void main() {
  group('SavingsGoal Domain Unit Tests', () {
    test('progressPercentage calculates ratio and clamps between 0.0 and 1.0', () {
      final goal = SavingsGoal(
        id: 'sg1',
        title: 'Emergency Fund',
        targetAmount: 10000,
        currentAmount: 5000,
        targetDate: DateTime.now().add(const Duration(days: 30)),
      );

      expect(goal.progressPercentage, equals(50.0));
      expect(goal.visualProgress, equals(0.5));
      expect(goal.remainingAmount, equals(5000));
      expect(goal.isAchieved, isFalse);
    });

    test('progressPercentage handles targetAmount == 0 safely without NaN', () {
      final goal = SavingsGoal(
        id: 'sg2',
        title: 'Zero Target Goal',
        targetAmount: 0,
        currentAmount: 100,
        targetDate: DateTime.now(),
      );

      expect(goal.progressPercentage, equals(0.0));
      expect(goal.visualProgress, equals(0.0));
      expect(goal.progressPercentage.isNaN, isFalse);
    });

    test('isAchieved returns true when currentAmount >= targetAmount', () {
      final goal = SavingsGoal(
        id: 'sg3',
        title: 'Laptop Savings',
        targetAmount: 50000,
        currentAmount: 55000,
        targetDate: DateTime.now(),
      );

      expect(goal.progressPercentage, closeTo(110.0, 0.001));
      expect(goal.visualProgress, equals(1.0));
      expect(goal.isAchieved, isTrue);
    });

    test('verifies exact PHASE FINANCE-08 Emergency Fund scenario', () {
      final goal = SavingsGoal(
        id: 'sg-emergency',
        title: 'Emergency Fund',
        targetAmount: 20000,
        currentAmount: 5000,
        targetDate: DateTime.now().add(const Duration(days: 180)),
      );

      expect(goal.targetAmount, equals(20000.0));
      expect(goal.currentAmount, equals(5000.0));
      expect(goal.remainingAmount, equals(15000.0));
      expect(goal.progressPercentage, equals(25.0));

      final updatedGoal = goal.copyWith(currentAmount: goal.currentAmount + 2000);
      expect(updatedGoal.targetAmount, equals(20000.0));
      expect(updatedGoal.currentAmount, equals(7000.0));
      expect(updatedGoal.remainingAmount, equals(13000.0));
      expect(updatedGoal.progressPercentage, equals(35.0));
    });
  });
}
