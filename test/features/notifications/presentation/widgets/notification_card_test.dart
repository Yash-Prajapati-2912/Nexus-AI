import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/notifications/domain/entities/notification_item.dart';
import 'package:nexus_ai/features/notifications/presentation/widgets/notification_card.dart';

void main() {
  final tNotification = NotificationItem(
    id: 'n1',
    userId: 'u1',
    title: 'Assignment Due',
    body: 'Submit by 11:59 PM',
    type: 'PLANNER',
    module: 'PLANNER',
    category: 'ASSIGNMENT',
    priority: 'HIGH',
    createdAt: DateTime.now(),
  );

  testWidgets('NotificationCard displays title, body, priority and module', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCard(
            item: tNotification,
            onTap: () {},
            onDismiss: () {},
          ),
        ),
      ),
    );

    expect(find.text('Assignment Due'), findsOneWidget);
    expect(find.text('Submit by 11:59 PM'), findsOneWidget);
    expect(find.text('HIGH'), findsOneWidget);
  });
}
