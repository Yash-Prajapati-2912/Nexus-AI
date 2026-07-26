import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/ai_finance/domain/entities/financial_health.dart';
import 'package:nexus_ai/features/ai_finance/presentation/widgets/financial_health_card.dart';

void main() {
  const tHealth = FinancialHealth(
    overallScore: 92,
    budgetHealthScore: 90,
    savingsScore: 95,
    expenseScore: 88,
    incomeStabilityScore: 94,
    cashFlowHealthScore: 91,
    investmentReadinessScore: 85,
    wellnessRating: 'EXCELLENT',
    summaryReasoning: 'Top tier financial score with high savings.',
    topStrengths: ['Emergency Fund'],
    keyRisks: [],
  );

  testWidgets('FinancialHealthCard renders score 92 and wellness rating correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FinancialHealthCard(health: tHealth),
        ),
      ),
    );

    expect(find.text('92'), findsOneWidget);
    expect(find.text('EXCELLENT'), findsOneWidget);
  });
}
