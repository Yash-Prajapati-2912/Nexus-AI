import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/storage/session_manager.dart';
import 'di/injection_container.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/settings/domain/entities/theme_entity.dart';
import 'features/settings/presentation/bloc/theme_bloc.dart';
import 'features/settings/presentation/bloc/theme_state.dart';
import 'l10n/l10n.dart';
import 'router/app_router.dart';
import 'router/navigation_service.dart';
import 'theme/app_theme.dart';

/// Root MaterialApp Container Widget with dynamic theme mode binding.
class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    final navService = NavigationService();
    final router = AppRouter.createRouter(sessionManager, navService.navigatorKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthenticationBloc>()),
        BlocProvider(create: (context) => getIt<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeMode currentThemeMode;
          switch (state.theme.themeMode) {
            case AppThemeMode.light:
              currentThemeMode = ThemeMode.light;
              break;
            case AppThemeMode.dark:
              currentThemeMode = ThemeMode.dark;
              break;
            case AppThemeMode.system:
              currentThemeMode = ThemeMode.system;
              break;
          }

          return MaterialApp.router(
            title: 'Nexus AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentThemeMode,
            routerConfig: router,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              final clampedScaler = mediaQuery.textScaler.clamp(
                minScaleFactor: 0.85,
                maxScaleFactor: 1.15,
              );
              return MediaQuery(
                data: mediaQuery.copyWith(textScaler: clampedScaler),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

