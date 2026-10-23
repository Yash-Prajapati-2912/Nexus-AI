import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/di/admin_injection.dart';
import 'core/theme/admin_theme.dart';
import 'router/admin_router.dart';
import 'features/auth/presentation/bloc/admin_auth_bloc.dart';

class NexusAdminApp extends StatelessWidget {
  const NexusAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AdminRouter.createRouter();

    return BlocProvider(
      create: (context) => AdminAuthBloc(getIt<SharedPreferences>()),
      child: MaterialApp.router(
        title: 'Nexus AI Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: AdminTheme.lightTheme,
        darkTheme: AdminTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}
