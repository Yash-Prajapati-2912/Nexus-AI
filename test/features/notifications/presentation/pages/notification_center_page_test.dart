import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/notifications/domain/entities/notification_item.dart';
import 'package:nexus_ai/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:nexus_ai/features/notifications/presentation/pages/notification_center_page.dart';
import 'package:nexus_ai/features/notifications/presentation/widgets/empty_notification_widget.dart';

class MockNotificationBloc extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

void main() {
  late MockNotificationBloc mockBloc;

  setUp(() {
    mockBloc = MockNotificationBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<NotificationBloc>.value(
        value: mockBloc,
        child: const NotificationCenterPage(),
      ),
    );
  }

  testWidgets('renders EmptyNotificationWidget and no sample notifications when notifications list is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const NotificationLoadedState(notifications: [], unreadCount: 0),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    // Verify empty state is rendered
    expect(find.byType(EmptyNotificationWidget), findsOneWidget);
    expect(find.text('No Notifications Yet'), findsOneWidget);

    // Verify hardcoded demo notifications are NOT displayed
    expect(find.text('Smart Planner: CS101 Assignment Due'), findsNothing);
    expect(find.text('AI Advisor: Unusual Spending Alert'), findsNothing);
    expect(find.text('AI Mentor: Study Recommendation'), findsNothing);
  });

  testWidgets('renders real notification item when state has notifications', (tester) async {
    final realNotification = NotificationItem(
      id: 'real-1',
      userId: 'u1',
      title: 'Real Notification Title',
      body: 'Real notification body message',
      type: 'PLANNER',
      module: 'PLANNER',
      category: 'ASSIGNMENT',
      priority: 'HIGH',
      createdAt: DateTime.now(),
    );

    when(() => mockBloc.state).thenReturn(
      NotificationLoadedState(notifications: [realNotification], unreadCount: 1),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Real Notification Title'), findsOneWidget);
    expect(find.text('Real notification body message'), findsOneWidget);
    expect(find.byType(EmptyNotificationWidget), findsNothing);
  });

  testWidgets('renders error view with retry button on NotificationFailureState', (tester) async {
    when(() => mockBloc.state).thenReturn(
      const NotificationFailureState('Connection failed'),
    );

    await tester.pumpWidget(buildTestWidget());
    await tester.pump();

    expect(find.text('Failed to load notifications'), findsOneWidget);
    expect(find.text('Connection failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
