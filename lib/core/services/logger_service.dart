import 'package:logger/logger.dart';
import '../../config/env/app_env.dart';

/// App Logger Service wrapper.
class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
    ),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (AppEnv.current.enableNetworkLogging) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void logCrash(dynamic error, StackTrace? stackTrace) {
    _logger.f('CRITICAL APP CRASH CATCH', error: error, stackTrace: stackTrace);
  }
}
