import 'app_logger.dart';

class CrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace? stackTrace, {String? reason, bool fatal = false}) async {
    AppLogger.error('CrashlyticsService: ${fatal ? "[FATAL]" : "[NON-FATAL]"} ${reason ?? "Exception occurred"}', exception, stackTrace);
  }

  Future<void> setCustomKey(String key, dynamic value) async {
    AppLogger.debug('CrashlyticsService: Custom key [$key: $value]');
  }

  Future<void> logBreadcrumb(String message) async {
    AppLogger.debug('CrashlyticsService: Breadcrumb [$message]');
  }

  Future<void> setUserIdentifier(String identifier) async {
    AppLogger.info('CrashlyticsService: User identifier bound [$identifier]');
  }
}
