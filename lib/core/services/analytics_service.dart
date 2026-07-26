import 'app_logger.dart';

class AnalyticsService {
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    AppLogger.info('AnalyticsService: Event [$eventName] - Params: $parameters');
  }

  Future<void> setCurrentScreen(String screenName) async {
    AppLogger.info('AnalyticsService: Screen View [$screenName]');
  }

  Future<void> setUserId(String userId) async {
    AppLogger.info('AnalyticsService: Set User ID [$userId]');
  }

  Future<void> logAIUsage({required String feature, required int tokenCount}) async {
    await logEvent('ai_feature_used', parameters: {
      'feature': feature,
      'token_count': tokenCount,
    });
  }

  Future<void> logPlannerTaskCreated({required String category}) async {
    await logEvent('planner_task_created', parameters: {'category': category});
  }

  Future<void> logExpenseCreated({required double amount, required String category}) async {
    await logEvent('finance_expense_created', parameters: {
      'amount': amount,
      'category': category,
    });
  }
}
