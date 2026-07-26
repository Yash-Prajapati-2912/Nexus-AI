import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/ai_planner/presentation/widgets/ai_insight_card.dart';

void main() {
  testWidgets('AIInsightCard renders title, description, and icon correctly', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AIInsightCard(
            title: 'Workload Analysis',
            description: 'Detect overloaded days',
            icon: Icons.bar_chart,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Workload Analysis'), findsOneWidget);
    expect(find.text('Detect overloaded days'), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);

    await tester.tap(find.byType(AIInsightCard));
    expect(tapped, isTrue);
  });
}
