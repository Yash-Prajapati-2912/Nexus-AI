import '../../domain/entities/forecast.dart';

class ForecastModel extends Forecast {
  const ForecastModel({
    required super.nextWeekForecastAmount,
    required super.nextMonthForecastAmount,
    required super.quarterlyForecastAmount,
    required super.yearlyForecastAmount,
    required super.predictedMonthEndSavings,
    required super.predictedOverspendingRisk,
    required super.overspendingProbability,
    required super.projectedCashFlowSeries,
    required super.forecastExplanation,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final rawSeries = json['projectedCashFlowSeries'] as List<dynamic>? ?? [];
    final series = rawSeries.map((e) => (e as num).toDouble()).toList();

    return ForecastModel(
      nextWeekForecastAmount: (json['nextWeekForecastAmount'] as num?)?.toDouble() ?? 0.00,
      nextMonthForecastAmount: (json['nextMonthForecastAmount'] as num?)?.toDouble() ?? (json['totalForecastedAmount'] as num?)?.toDouble() ?? 0.00,
      quarterlyForecastAmount: (json['quarterlyForecastAmount'] as num?)?.toDouble() ?? 0.00,
      yearlyForecastAmount: (json['yearlyForecastAmount'] as num?)?.toDouble() ?? 0.00,
      predictedMonthEndSavings: (json['predictedMonthEndSavings'] as num?)?.toDouble() ?? (json['predictedMonthEndBalance'] as num?)?.toDouble() ?? 0.00,
      predictedOverspendingRisk: json['predictedOverspendingRisk'] as bool? ?? false,
      overspendingProbability: (json['overspendingProbability'] as num?)?.toDouble() ?? 0.0,
      projectedCashFlowSeries: series,
      forecastExplanation: json['summary'] as String? ?? json['forecastExplanation'] as String? ?? json['explanation'] as String? ?? 'No expense forecast available.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextWeekForecastAmount': nextWeekForecastAmount,
      'nextMonthForecastAmount': nextMonthForecastAmount,
      'quarterlyForecastAmount': quarterlyForecastAmount,
      'yearlyForecastAmount': yearlyForecastAmount,
      'predictedMonthEndSavings': predictedMonthEndSavings,
      'predictedOverspendingRisk': predictedOverspendingRisk,
      'overspendingProbability': overspendingProbability,
      'projectedCashFlowSeries': projectedCashFlowSeries,
      'forecastExplanation': forecastExplanation,
    };
  }
}
