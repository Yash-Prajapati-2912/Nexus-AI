import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_bloc.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_event.dart';
import 'package:nexus_ai/features/ai_planner/presentation/bloc/ai_planner_state.dart';
import 'package:nexus_ai/features/ai_planner/presentation/pages/monthly_planning_page.dart';
import 'package:nexus_ai/features/ai_planner/presentation/pages/saved_ai_plans_page.dart';
import 'package:nexus_ai/features/ai_planner/presentation/pages/weekly_planning_page.dart';

class MockAIPlannerBloc extends MockBloc<AIPlannerEvent, AIPlannerState>
    implements AIPlannerBloc {}

void main() {
  late MockAIPlannerBloc mockBloc;

  setUp(() {
    mockBloc = MockAIPlannerBloc();
  });

  group('WeeklyPlanningPage', () {
    testWidgets('renders honest empty state and no hardcoded CS schedule cards when study plan is absent', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const AIPlannerLoadedState(currentStudyPlan: null),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AIPlannerBloc>.value(
            value: mockBloc,
            child: const WeeklyPlanningPage(),
          ),
        ),
      );
      await tester.pump();

      // Honest empty state
      expect(find.text('No Active Weekly Study Plan'), findsOneWidget);
      expect(find.text('Generate Study Plan'), findsOneWidget);

      // Hardcoded demo schedule cards removed
      expect(find.text('Computer Science'), findsNothing);
      expect(find.text('Linear Algebra'), findsNothing);
      expect(find.text('Physics Lab'), findsNothing);
    });
  });

  group('MonthlyPlanningPage', () {
    testWidgets('renders honest empty state and no hardcoded July 2026 exam dates when no milestones exist', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const AIPlannerLoadedState(deadlineRisk: null),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AIPlannerBloc>.value(
            value: mockBloc,
            child: const MonthlyPlanningPage(),
          ),
        ),
      );
      await tester.pump();

      // Honest empty state
      expect(find.text('No Academic Milestones'), findsOneWidget);
      expect(find.text('Generate AI Blueprint'), findsOneWidget);

      // Hardcoded fabricated exams removed
      expect(find.text('Midterm Exam: Data Structures'), findsNothing);
      expect(find.text('July 28, 2026'), findsNothing);
      expect(find.text('Linear Algebra Term Paper Submission'), findsNothing);
    });
  });

  group('SavedAIPlansPage', () {
    testWidgets('renders honest empty state and no hardcoded Midterm Crunch 7-Day Plan', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const AIPlannerLoadedState(savedPlans: []),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AIPlannerBloc>.value(
            value: mockBloc,
            child: const SavedAIPlansPage(),
          ),
        ),
      );
      await tester.pump();

      // Honest empty state
      expect(find.text('No Saved AI Plans Yet'), findsOneWidget);

      // Hardcoded demo plan removed
      expect(find.text('Midterm Crunch 7-Day Plan'), findsNothing);
    });
  });
}
