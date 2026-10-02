import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:nexus_ai/features/authentication/presentation/pages/login_page.dart';
import 'package:nexus_ai/features/authentication/presentation/widgets/loading_overlay.dart';
import 'package:nexus_ai/shared/widgets/primary_button.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class FakeAuthenticationEvent extends Fake implements AuthenticationEvent {}

void main() {
  late MockAuthenticationBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthenticationBloc();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<AuthenticationBloc>.value(
        value: mockAuthBloc,
        child: child,
      ),
    );
  }

  group('LoginPage Loader & Submission Tests (AUTH-UI-02)', () {
    testWidgets('renders login form with no screen-level loader initially',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(UnauthenticatedState());

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(LoadingOverlay), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'when AuthLoadingState is active, only the PrimaryButton displays spinner and no screen overlay exists',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoadingState());

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));

      // Verify NO screen-level LoadingOverlay widget
      expect(find.byType(LoadingOverlay), findsNothing);

      // Verify exactly ONE CircularProgressIndicator exists on screen
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify that this single loader is inside the PrimaryButton
      final buttonFinder = find.byType(PrimaryButton);
      expect(buttonFinder, findsOneWidget);
      expect(
        find.descendant(
          of: buttonFinder,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      // Verify form elements and logo remain visible and not covered by an overlay
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('submitting form triggers LoginRequestedEvent',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(UnauthenticatedState());

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));

      // Enter valid email and password
      final emailField = find.byType(TextFormField).at(0);
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'Password123!');

      // Tap Sign In
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      verify(() => mockAuthBloc.add(any(that: isA<LoginRequestedEvent>())))
          .called(1);
    });

    testWidgets(
        'repeated clicks while loading are blocked and do not trigger extra events',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoadingState());

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));

      // Attempt to tap the loading button
      final buttonFinder = find.byType(PrimaryButton);
      await tester.tap(buttonFinder, warnIfMissed: false);
      await tester.pump();

      // No LoginRequestedEvent should be dispatched
      verifyNever(() => mockAuthBloc.add(any()));
    });

    testWidgets(
        'when AuthFailureState occurs, error snackbar is shown and button spinner is gone',
        (tester) async {
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          AuthLoadingState(),
          const AuthFailureState(message: 'Invalid credentials'),
        ]),
        initialState: UnauthenticatedState(),
      );

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));
      await tester.pump(); // Deliver AuthLoadingState
      await tester.pump(); // Deliver AuthFailureState
      await tester.pump(const Duration(milliseconds: 100));

      // Button spinner is gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Sign In'), findsOneWidget);

      // Error message is displayed in SnackBar
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('invalid form input shows validation error and does not submit',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(UnauthenticatedState());

      await tester.pumpWidget(buildTestableWidget(const LoginPage()));

      // Tap Sign In with empty fields
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      verifyNever(() => mockAuthBloc.add(any()));
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
  });
}
