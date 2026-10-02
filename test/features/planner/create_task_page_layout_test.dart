import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/features/planner/presentation/pages/create_task_page.dart';
import 'package:nexus_ai/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:nexus_ai/features/planner/presentation/bloc/planner_event.dart';
import 'package:nexus_ai/features/planner/presentation/bloc/planner_state.dart';

class SimplePlannerBloc extends Bloc<PlannerEvent, PlannerState> implements PlannerBloc {
  SimplePlannerBloc() : super(PlannerInitialState());
}

void main() {
  testWidgets('CreateTaskPage renders cleanly on Desktop (1200x800) across tabs', (tester) async {
    final plannerBloc = SimplePlannerBloc();
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PlannerBloc>.value(
          value: plannerBloc,
          child: const CreateTaskPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Academic Task'), findsOneWidget);
    expect(find.text('Analyze Document'), findsOneWidget);
    expect(find.text('Add Manually'), findsOneWidget);
    expect(find.text('Tap to upload Document or PDF'), findsOneWidget);

    // Switch to Add Manually Tab
    await tester.tap(find.text('Add Manually'));
    await tester.pumpAndSettle();

    expect(find.text('Task Title'), findsOneWidget);
    expect(find.text('Subject / Course Code'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Priority'), findsOneWidget);
    expect(find.text('Create Task'), findsOneWidget);

    await plannerBloc.close();
  });

  testWidgets('CreateTaskPage renders cleanly on Mobile (375x812) across tabs without overflow', (tester) async {
    final plannerBloc = SimplePlannerBloc();
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PlannerBloc>.value(
          value: plannerBloc,
          child: const CreateTaskPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Academic Task'), findsOneWidget);
    expect(find.text('Analyze Document'), findsOneWidget);
    expect(find.text('Add Manually'), findsOneWidget);
    expect(find.text('Tap to upload Document or PDF'), findsOneWidget);

    // Switch to Add Manually Tab
    await tester.tap(find.text('Add Manually'));
    await tester.pumpAndSettle();

    expect(find.text('Task Title'), findsOneWidget);
    expect(find.text('Subject / Course Code'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Priority'), findsOneWidget);
    expect(find.text('Create Task'), findsOneWidget);

    // Enter text and verify form responds
    await tester.enterText(find.byType(TextFormField).first, 'Math Homework');
    await tester.pumpAndSettle();
    expect(find.text('Math Homework'), findsOneWidget);

    await plannerBloc.close();
  });
}
