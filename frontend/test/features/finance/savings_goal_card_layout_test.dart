import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/presentation/widgets/savings_goal_card.dart';

void main() {
  testWidgets('SavingsGoalCard renders cleanly in a 280px width container without overflow', (tester) async {
    final goal = SavingsGoal(
      id: 'g1',
      title: 'Laptop',
      targetAmount: 250000,
      currentAmount: 25000,
      targetDate: DateTime(2027, 3, 30),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              height: 180,
              child: SavingsGoalCard(goal: goal),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Saved: ₹25000'), findsOneWidget);
    expect(find.text('Remaining: ₹225000'), findsNothing);
    expect(find.text('Target: ₹250000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
