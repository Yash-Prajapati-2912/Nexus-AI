import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/presentation/widgets/expense_card.dart';

void main() {
  final tExpense = Expense(
    id: 'exp-100',
    title: 'Textbook Purchase',
    amount: 75.00,
    categoryId: 'c-edu',
    categoryName: 'Education',
    categoryIcon: 'school',
    date: DateTime(2026, 7, 26),
  );

  testWidgets('ExpenseCard renders title, category, and formatted amount correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpenseCard(expense: tExpense),
        ),
      ),
    );

    expect(find.text('Textbook Purchase'), findsOneWidget);
    expect(find.textContaining('Education'), findsOneWidget);
    expect(find.text('-\$75.00'), findsOneWidget);
  });
}
