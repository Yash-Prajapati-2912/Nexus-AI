import 'package:equatable/equatable.dart';

/// Domain entity for AI Expense Forecast & Cash Flow Prediction.
class Forecast extends Equatable {
  final double nextWeekForecastAmount;
  final double nextMonthForecastAmount;
  final double quarterlyForecastAmount;
  final double yearlyForecastAmount;
  final double predictedMonthEndSavings;
  final bool predictedOverspendingRisk;
  final double overspendingProbability;
  final List<double> projectedCashFlowSeries;
  final String forecastExplanation;

  const Forecast({
    required this.nextWeekForecastAmount,
    required this.nextMonthForecastAmount,
    required this.quarterlyForecastAmount,
    required this.yearlyForecastAmount,
    required this.predictedMonthEndSavings,
    required this.predictedOverspendingRisk,
    required this.overspendingProbability,
    required this.projectedCashFlowSeries,
    required this.forecastExplanation,
  });

  @override
  List<Object?> get props => [
        nextWeekForecastAmount,
        nextMonthForecastAmount,
        quarterlyForecastAmount,
        yearlyForecastAmount,
        predictedMonthEndSavings,
        predictedOverspendingRisk,
        overspendingProbability,
        projectedCashFlowSeries,
        forecastExplanation,
      ];
}
