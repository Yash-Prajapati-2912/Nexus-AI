import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:nexus_ai/features/settings/data/models/theme_model.dart';
import 'package:nexus_ai/features/settings/data/models/language_model.dart';
import 'package:nexus_ai/features/settings/data/models/accessibility_model.dart';
import 'package:nexus_ai/features/settings/domain/entities/theme_entity.dart';
import 'package:nexus_ai/features/settings/domain/entities/language_entity.dart';
import 'package:nexus_ai/features/settings/domain/entities/accessibility_entity.dart';
import 'package:nexus_ai/features/settings/domain/entities/security_entity.dart';
import 'package:nexus_ai/features/settings/domain/entities/backup_entity.dart';
import 'package:nexus_ai/features/settings/domain/entities/privacy_entity.dart';
import 'package:nexus_ai/features/settings/domain/usecases/update_theme_usecase.dart';
import 'package:nexus_ai/features/settings/domain/usecases/update_language_usecase.dart';
import 'package:nexus_ai/features/settings/domain/usecases/update_accessibility_usecase.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/theme_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/security_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/security_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/security_state.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/session_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/session_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/session_state.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/backup_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/backup_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/backup_state.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/privacy_bloc.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/privacy_event.dart';
import 'package:nexus_ai/features/settings/presentation/bloc/privacy_state.dart';
import 'package:nexus_ai/features/settings/presentation/pages/security_settings_page.dart';
import 'package:nexus_ai/features/settings/presentation/pages/session_management_page.dart';
import 'package:nexus_ai/features/settings/presentation/pages/backup_restore_page.dart';
import 'package:nexus_ai/features/settings/presentation/pages/privacy_settings_page.dart';

class MockSettingsLocalDataSource extends Mock implements ISettingsLocalDataSource {}
class MockUpdateThemeUseCase extends Mock implements UpdateThemeUseCase {}
class MockUpdateLanguageUseCase extends Mock implements UpdateLanguageUseCase {}
class MockUpdateAccessibilityUseCase extends Mock implements UpdateAccessibilityUseCase {}

class MockSecurityBloc extends MockBloc<SecurityEvent, SecurityState> implements SecurityBloc {}
class MockSessionBloc extends MockBloc<SessionEvent, SessionState> implements SessionBloc {}
class MockBackupBloc extends MockBloc<BackupEvent, BackupState> implements BackupBloc {}
class MockPrivacyBloc extends MockBloc<PrivacyEvent, PrivacyState> implements PrivacyBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeEntity.initial());
    registerFallbackValue(LanguageEntity.initial());
    registerFallbackValue(AccessibilityEntity.initial());
  });

  group('Phase 4: ThemeBloc Persistence & Settings Initialization', () {
    late MockSettingsLocalDataSource mockLocalDataSource;
    late MockUpdateThemeUseCase mockUpdateThemeUseCase;
    late MockUpdateLanguageUseCase mockUpdateLanguageUseCase;
    late MockUpdateAccessibilityUseCase mockUpdateAccessibilityUseCase;

    setUp(() {
      mockLocalDataSource = MockSettingsLocalDataSource();
      mockUpdateThemeUseCase = MockUpdateThemeUseCase();
      mockUpdateLanguageUseCase = MockUpdateLanguageUseCase();
      mockUpdateAccessibilityUseCase = MockUpdateAccessibilityUseCase();
    });

    test('loads persisted theme, language, and accessibility preferences on initialization', () async {
      const savedTheme = ThemeModel(
        themeMode: AppThemeMode.dark,
        useDynamicColor: false,
        primaryColorHex: '0xFFB91D47',
        isMaterial3: true,
        fontScale: 1.0,
      );
      const savedLang = LanguageModel(
        languageCode: 'es',
        regionCode: 'ES',
        dateFormat: 'DD/MM/YYYY',
        timeFormat: '24h',
        numberFormat: 'standard',
        timezone: 'UTC',
      );
      const savedAcc = AccessibilityModel(
        largeTextEnabled: true,
        highContrastEnabled: true,
        reduceMotionEnabled: true,
        screenReaderOptimized: false,
        touchTargetScale: 1.0,
      );

      when(() => mockLocalDataSource.getTheme()).thenAnswer((_) async => savedTheme);
      when(() => mockLocalDataSource.getLanguage()).thenAnswer((_) async => savedLang);
      when(() => mockLocalDataSource.getAccessibility()).thenAnswer((_) async => savedAcc);

      final bloc = ThemeBloc(
        updateThemeUseCase: mockUpdateThemeUseCase,
        updateLanguageUseCase: mockUpdateLanguageUseCase,
        updateAccessibilityUseCase: mockUpdateAccessibilityUseCase,
        localDataSource: mockLocalDataSource,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.theme.themeMode, equals(AppThemeMode.dark));
      expect(bloc.state.theme.primaryColorHex, equals('0xFFB91D47'));
      expect(bloc.state.language.languageCode, equals('es'));
      expect(bloc.state.accessibility.largeTextEnabled, isTrue);
      expect(bloc.state.accessibility.highContrastEnabled, isTrue);
      expect(bloc.state.accessibility.reduceMotionEnabled, isTrue);

      await bloc.close();
    });

    test('updates language selection via updateLanguageUseCase on UpdateLanguageSettingsEvent', () async {
      when(() => mockLocalDataSource.getTheme()).thenAnswer((_) async => null);
      when(() => mockLocalDataSource.getLanguage()).thenAnswer((_) async => null);
      when(() => mockLocalDataSource.getAccessibility()).thenAnswer((_) async => null);
      when(() => mockUpdateLanguageUseCase(any()))
          .thenAnswer((_) async => Right(LanguageEntity.initial().copyWith(languageCode: 'fr')));

      final bloc = ThemeBloc(
        updateThemeUseCase: mockUpdateThemeUseCase,
        updateLanguageUseCase: mockUpdateLanguageUseCase,
        updateAccessibilityUseCase: mockUpdateAccessibilityUseCase,
        localDataSource: mockLocalDataSource,
      );

      final newLang = LanguageEntity.initial().copyWith(languageCode: 'fr');
      bloc.add(UpdateLanguageSettingsEvent(newLang));

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.language.languageCode, equals('fr'));
      verify(() => mockUpdateLanguageUseCase(newLang)).called(1);

      await bloc.close();
    });

    test('updates accessibility options via updateAccessibilityUseCase on UpdateAccessibilitySettingsEvent', () async {
      when(() => mockLocalDataSource.getTheme()).thenAnswer((_) async => null);
      when(() => mockLocalDataSource.getLanguage()).thenAnswer((_) async => null);
      when(() => mockLocalDataSource.getAccessibility()).thenAnswer((_) async => null);
      when(() => mockUpdateAccessibilityUseCase(any()))
          .thenAnswer((_) async => Right(AccessibilityEntity.initial().copyWith(largeTextEnabled: true)));

      final bloc = ThemeBloc(
        updateThemeUseCase: mockUpdateThemeUseCase,
        updateLanguageUseCase: mockUpdateLanguageUseCase,
        updateAccessibilityUseCase: mockUpdateAccessibilityUseCase,
        localDataSource: mockLocalDataSource,
      );

      final newAcc = AccessibilityEntity.initial().copyWith(largeTextEnabled: true, reduceMotionEnabled: true);
      bloc.add(UpdateAccessibilitySettingsEvent(newAcc));

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.accessibility.largeTextEnabled, isTrue);
      expect(bloc.state.accessibility.reduceMotionEnabled, isTrue);
      verify(() => mockUpdateAccessibilityUseCase(newAcc)).called(1);

      await bloc.close();
    });
  });

  group('Phase 4: Security Settings UI & Confirmation Dialogs', () {
    late MockSecurityBloc mockSecurityBloc;

    setUp(() {
      mockSecurityBloc = MockSecurityBloc();
    });

    testWidgets('Biometric and PIN lock are displayed as disabled/unavailable', (tester) async {
      when(() => mockSecurityBloc.state).thenReturn(
        SecurityLoaded(SecurityEntity.initial()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SecurityBloc>.value(
            value: mockSecurityBloc,
            child: const SecuritySettingsPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Biometric Lock'), findsOneWidget);
      expect(find.text('Platform biometric authentication is not available on this device'), findsOneWidget);
      expect(find.text('PIN Lock'), findsOneWidget);
      expect(find.text('App PIN lock setup is not available yet'), findsOneWidget);

      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(2));
      for (final switchFinder in switches.evaluate()) {
        final switchWidget = switchFinder.widget as Switch;
        expect(switchWidget.onChanged, isNull);
      }
    });

    testWidgets('Tapping Logout All shows destructive confirmation dialog before executing', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockSecurityBloc.state).thenReturn(
        SecurityLoaded(SecurityEntity.initial()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SecurityBloc>.value(
            value: mockSecurityBloc,
            child: const SecuritySettingsPage(),
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('Logout All'));
      await tester.pump();
      await tester.tap(find.text('Logout All'));
      await tester.pump();

      expect(find.text('Terminate Other Sessions?'), findsOneWidget);
      expect(find.text('Are you sure you want to log out of all other devices? All other active sessions will be terminated.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(find.text('Terminate Other Sessions?'), findsNothing);
    });
  });

  group('Phase 4: Session Management Honest Empty States', () {
    late MockSessionBloc mockSessionBloc;

    setUp(() {
      mockSessionBloc = MockSessionBloc();
    });

    testWidgets('displays honest empty state when no active remote sessions exist', (tester) async {
      when(() => mockSessionBloc.state).thenReturn(
        const SessionLoaded(sessions: [], devices: []),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SessionBloc>.value(
            value: mockSessionBloc,
            child: const SessionManagementPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No active remote sessions found'), findsOneWidget);
      expect(find.byIcon(Icons.devices), findsOneWidget);
    });
  });

  group('Phase 4: Backup & Restore Explicit Unavailable State', () {
    late MockBackupBloc mockBackupBloc;

    setUp(() {
      mockBackupBloc = MockBackupBloc();
    });

    testWidgets('displays unavailable banner and disables fake restore action', (tester) async {
      when(() => mockBackupBloc.state).thenReturn(
        BackupSuccess(
          BackupEntity.initial().copyWith(
            status: 'UNAVAILABLE',
            autoBackupEnabled: false,
            cloudSyncEnabled: false,
          ),
          'Ready',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BackupBloc>.value(
            value: mockBackupBloc,
            child: const BackupRestorePage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Cloud Backup & Automated Restore is currently unavailable. Server-side backup storage infrastructure is not configured.'), findsOneWidget);
      expect(find.textContaining('UNAVAILABLE'), findsOneWidget);

      final restoreButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Restore'));
      expect(restoreButton.onPressed, isNull);
    });
  });

  group('Phase 4: Privacy Settings & AI Chat History Semantics', () {
    late MockPrivacyBloc mockPrivacyBloc;

    setUp(() {
      mockPrivacyBloc = MockPrivacyBloc();
    });

    testWidgets('informs user that AI history can be managed individually from AI Mentor', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      when(() => mockPrivacyBloc.state).thenReturn(
        PrivacyLoaded(PrivacyEntity.initial()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PrivacyBloc>.value(
            value: mockPrivacyBloc,
            child: const PrivacySettingsPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('AI Conversation History'), findsOneWidget);
      expect(find.text('Manage or delete chat logs directly inside AI Mentor'), findsOneWidget);

      await tester.ensureVisible(find.text('Manage Chats'));
      await tester.pump();
      await tester.tap(find.text('Manage Chats'));
      await tester.pump();

      expect(find.text('AI Conversation Management'), findsOneWidget);
      expect(find.text('Bulk conversation deletion is not supported by the backend. To delete or archive chats, open AI Mentor and use the delete option on individual conversations in the history menu.'), findsOneWidget);

      await tester.tap(find.text('Understood'));
      await tester.pump();

      expect(find.text('AI Conversation Management'), findsNothing);
    });
  });
}
