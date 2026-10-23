import 'package:equatable/equatable.dart';

abstract class AIFinanceEvent extends Equatable {
  const AIFinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinancialHealthEvent extends AIFinanceEvent {
  const LoadFinancialHealthEvent();
}

class LoadInsightsEvent extends AIFinanceEvent {
  const LoadInsightsEvent();
}

class LoadForecastEvent extends AIFinanceEvent {
  const LoadForecastEvent();
}

class LoadRecommendationsEvent extends AIFinanceEvent {
  const LoadRecommendationsEvent();
}

class LoadSubscriptionsEvent extends AIFinanceEvent {
  const LoadSubscriptionsEvent();
}

class LoadGoalsEvent extends AIFinanceEvent {
  const LoadGoalsEvent();
}

class RefreshAIFinanceDashboardEvent extends AIFinanceEvent {
  const RefreshAIFinanceDashboardEvent();
}

class SaveInsightEvent extends AIFinanceEvent {
  final String reportId;

  const SaveInsightEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

class DeleteInsightEvent extends AIFinanceEvent {
  final String reportId;

  const DeleteInsightEvent(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
