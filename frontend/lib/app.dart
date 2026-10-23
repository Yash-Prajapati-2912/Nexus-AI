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
          final currentThemeMode = switch (state.theme.themeMode) {
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
            AppThemeMode.system => ThemeMode.system,
          };

          Color? primaryColor;
          try {
            final hex = state.theme.primaryColorHex.replaceAll('#', '').replaceFirst('0x', '');
            primaryColor = Color(int.parse(hex, radix: 16));
          } catch (_) {}

          final isHighContrast = state.accessibility.highContrastEnabled;
          final isLargeText = state.accessibility.largeTextEnabled;
          final textScale = isLargeText ? 1.25 : state.theme.fontScale;

          return MaterialApp.router(
            title: 'Nexus AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightThemeWith(
              primaryColor: primaryColor,
              highContrast: isHighContrast,
            ),
            darkTheme: AppTheme.darkThemeWith(
              primaryColor: primaryColor,
              highContrast: isHighContrast,
            ),
            themeMode: currentThemeMode,
            locale: Locale(state.language.languageCode),
            routerConfig: router,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.linear(textScale),
                  disableAnimations: state.accessibility.reduceMotionEnabled,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

