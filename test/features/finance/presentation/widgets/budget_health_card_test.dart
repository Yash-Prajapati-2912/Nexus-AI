import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/presentation/widgets/budget_health_card.dart';

void main() {
  group('BudgetHealthCard Widget Tests', () {
    testWidgets('renders correct labels, normal daily budget, and safe daily limit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetHealthCard(
              plannedAmount: 15000.0,
              currentSpent: 3000.0,
              currencySymbol: '₹',
              daysInMonth: 30,
              elapsedDays: 15,
              remainingDays: 15,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Budget Health'), findsOneWidget);

      // Verify Metric Labels
      expect(find.text('Days Remaining'), findsOneWidget);
      expect(find.text('15 days'), findsOneWidget);

      expect(find.text('Daily Budget'), findsOneWidget);
      expect(find.text('₹500/day'), findsOneWidget);

      expect(find.text('Safe to Spend / Day'), findsOneWidget);
      expect(find.text('₹800/day'), findsOneWidget);

      expect(find.text('Projected Month-End'), findsOneWidget);
      expect(find.text('₹6000'), findsOneWidget);

      // Verify radial contents
      expect(find.text('20%'), findsOneWidget);
      expect(find.text('₹12000'), findsOneWidget);
      expect(find.text('remaining'), findsOneWidget);
    });

    testWidgets('renders Safe to Spend Today on final day of month', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetHealthCard(
              plannedAmount: 15000.0,
              currentSpent: 3000.0,
              currencySymbol: '₹',
              daysInMonth: 30,
              elapsedDays: 30,
              remainingDays: 1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Safe to Spend Today'), findsOneWidget);
      expect(find.text('₹12000/day'), findsOneWidget);
      expect(find.text('Final day buffer'), findsOneWidget);
      expect(find.text('₹500/day'), findsOneWidget); // Normal daily budget is still ₹500/day!
    });

    testWidgets('renders No Active Budget Set when plannedAmount <= 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetHealthCard(
              plannedAmount: 0.0,
              currentSpent: 0.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Active Budget Set'), findsOneWidget);
      expect(find.text('Set Budget'), findsWidgets);
    });
  });
}
