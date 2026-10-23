import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus_ai/di/injection_container.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:nexus_ai/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:nexus_ai/features/profile/presentation/bloc/account_bloc.dart';
import 'package:nexus_ai/features/profile/presentation/pages/delete_account_page.dart';

class MockAccountBloc extends MockBloc<AccountEvent, AccountState> implements AccountBloc {}
class MockAuthenticationBloc extends MockBloc<AuthenticationEvent, AuthenticationState> implements AuthenticationBloc {}

void main() {
  late MockAccountBloc mockAccountBloc;
  late MockAuthenticationBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(const TriggerDeleteAccountEvent());
    registerFallbackValue(LogoutRequestedEvent());
  });

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockAuthBloc = MockAuthenticationBloc();

    if (getIt.isRegistered<AccountBloc>()) {
      getIt.unregister<AccountBloc>();
    }
    getIt.registerFactory<AccountBloc>(() => mockAccountBloc);
  });

  tearDown(() {
    if (getIt.isRegistered<AccountBloc>()) {
      getIt.unregister<AccountBloc>();
    }
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthenticationBloc>.value(
        value: mockAuthBloc,
        child: const DeleteAccountPage(),
      ),
    );
  }

  group('DeleteAccountPage Tests', () {
    testWidgets('button is disabled until "DELETE" is entered', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitialState());

      await tester.pumpWidget(buildTestableWidget());

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Permanently Delete My Account');
      expect(buttonFinder, findsOneWidget);

      ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'del');
      await tester.pump();
      button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'DELETE');
      await tester.pump();
      button = tester.widget(buttonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('clicking button when confirmed triggers TriggerDeleteAccountEvent', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitialState());

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), 'DELETE');
      await tester.pump();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Permanently Delete My Account');
      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockAccountBloc.add(const TriggerDeleteAccountEvent())).called(1);
    });

    testWidgets('shows loading spinner when AccountLoadingState is active', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountLoadingState());

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error snackbar when AccountFailureState is emitted', (tester) async {
      whenListen(
        mockAccountBloc,
        Stream.fromIterable([
          const AccountFailureState('Database connection failed'),
        ]),
        initialState: const AccountInitialState(),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Failed to delete account: Database connection failed'), findsOneWidget);
    });
  });
}
