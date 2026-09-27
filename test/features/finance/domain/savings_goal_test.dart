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

      expect(goal.progressPercentage, equals(0.5));
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

      expect(goal.progressPercentage, equals(1.0));
      expect(goal.isAchieved, isTrue);
      expect(goal.remainingAmount, equals(-5000));
    });
  });
}
