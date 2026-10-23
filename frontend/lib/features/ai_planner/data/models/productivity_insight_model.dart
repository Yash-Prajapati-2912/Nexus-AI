import '../../domain/entities/productivity_insight.dart';

class ProductivityInsightModel extends ProductivityInsight {
  const ProductivityInsightModel({
    required super.studyStreakDays,
    required super.bestStudyHours,
    required super.focusTimeHours,
    required super.completionRatePercentage,
    required super.productivityScore,
    required super.weeklyTrends,
    required super.monthlyTrends,
    required super.keyTakeaways,
  });

  factory ProductivityInsightModel.fromJson(Map<String, dynamic> json) {
    final rawWeekly = json['weeklyTrends'] as List<dynamic>? ?? [65.0, 70.0, 80.0, 75.0, 90.0, 85.0, 95.0];
    final weeklyTrends = rawWeekly.map((e) => (e as num).toDouble()).toList();

    final rawMonthly = json['monthlyTrends'] as List<dynamic>? ?? [72.0, 78.0, 84.0, 89.0];
    final monthlyTrends = rawMonthly.map((e) => (e as num).toDouble()).toList();

    final rawTakeaways = json['keyTakeaways'] as List<dynamic>? ?? [];
    final keyTakeaways = rawTakeaways.map((e) => e.toString()).toList();

    return ProductivityInsightModel(
      studyStreakDays: json['studyStreakDays'] as int? ?? 5,
      bestStudyHours: json['bestStudyHours'] as String? ?? '08:00 AM - 11:00 AM',
      focusTimeHours: (json['focusTimeHours'] as num?)?.toDouble() ?? 4.5,
      completionRatePercentage: (json['completionRatePercentage'] as num?)?.toDouble() ?? 88.5,
      productivityScore: (json['productivityScore'] as num?)?.toDouble() ?? 92.0,
      weeklyTrends: weeklyTrends,
      monthlyTrends: monthlyTrends,
      keyTakeaways: keyTakeaways,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studyStreakDays': studyStreakDays,
      'bestStudyHours': bestStudyHours,
      'focusTimeHours': focusTimeHours,
      'completionRatePercentage': completionRatePercentage,
      'productivityScore': productivityScore,
      'weeklyTrends': weeklyTrends,
      'monthlyTrends': monthlyTrends,
      'keyTakeaways': keyTakeaways,
    };
  }
}
