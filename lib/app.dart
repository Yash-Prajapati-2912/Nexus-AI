import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/storage/session_manager.dart';
import 'di/injection_container.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'l10n/l10n.dart';
import 'router/app_router.dart';
import 'router/navigation_service.dart';
import 'theme/app_theme.dart';

/// Root MaterialApp Container Widget.
class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();
    final navService = NavigationService();
    final router = AppRouter.createRouter(sessionManager, navService.navigatorKey);

    return BlocProvider(
      create: (context) => getIt<AuthenticationBloc>(),
      child: MaterialApp.router(
        title: 'Nexus AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
