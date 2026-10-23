import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai_admin/features/dashboard/presentation/pages/admin_dashboard_page.dart';

void main() {
  testWidgets('AdminDashboardPage renders headline and executive cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AdminDashboardPage(),
        ),
      ),
    );

    expect(find.text('Executive Platform Dashboard'), findsOneWidget);
    expect(find.text('Total Active Users'), findsOneWidget);
    expect(find.text('AI Tokens Processed'), findsOneWidget);
  });
}
