import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/env/app_env.dart';
import 'core/services/app_logger.dart';
import 'core/services/remote_config_service.dart';
import 'core/security/security_service.dart';
import 'core/offline/sync_manager.dart';
import 'core/optimization/image_cache_manager.dart';
import 'di/injection_container.dart';

/// Global BLoC Observer logging state transitions cleanly.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug('BLoC Change [${bloc.runtimeType}]: $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error('BLoC Error [${bloc.runtimeType}]', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

/// Global Application Bootstrapper executing initialization sequence.
Future<void> bootstrap(AppEnv env, Widget Function() builder) async {
  FlutterError.onError = (details) {
    AppLogger.error('Unhandled Flutter Framework Error', details.exception, details.stack);
  };

  Bloc.observer = AppBlocObserver();

  unawaited(
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await configureDependencies(env);

        // Configure Image Cache
        ImageCacheManager.configureImageCache();

        // Initialize Security Hardening
        final securityService = getIt<SecurityService>();
        await securityService.initializeSecurityHardening();

        // Fetch Remote Config
        final remoteConfig = getIt<RemoteConfigService>();
        await remoteConfig.fetchAndActivate();

        // Initialize Sync Engine
        final syncManager = getIt<SyncManager>();
        syncManager.initialize();

        runApp(builder());
      },
      (error, stackTrace) {
        AppLogger.error('Unhandled Async Zone Exception', error, stackTrace);
      },
    ),
  );
}
