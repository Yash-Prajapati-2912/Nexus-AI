import '../../domain/entities/spending_insight.dart';

class CategorySpendingShareModel extends CategorySpendingShare {
  const CategorySpendingShareModel({
    required super.categoryName,
    required super.amount,
    required super.percentage,
    required super.trendDirection,
  });

  factory CategorySpendingShareModel.fromJson(Map<String, dynamic> json) {
    return CategorySpendingShareModel(
      categoryName: json['categoryName'] as String? ?? json['category'] as String? ?? 'General',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      trendDirection: json['trendDirection'] as String? ?? 'STABLE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'amount': amount,
      'percentage': percentage,
      'trendDirection': trendDirection,
    };
  }
}

class SpendingInsightModel extends SpendingInsight {
  const SpendingInsightModel({
    required super.dailyAverageSpent,
    required super.monthlyComparisonPercentage,
    required super.weeklyComparisonPercentage,
    required super.highestCategories,
    required super.lifestyleAnalysis,
    required super.detectedAnomalies,
    required super.confidenceScore,
  });

  factory SpendingInsightModel.fromJson(Map<String, dynamic> json) {
    final rawCats = json['highestCategories'] as List<dynamic>? ?? [];
    final categories = rawCats
        .map((e) => CategorySpendingShareModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawAnomalies = json['detectedAnomalies'] as List<dynamic>? ?? [];
    final anomalies = rawAnomalies.map((e) => e.toString()).toList();

    return SpendingInsightModel(
      dailyAverageSpent: (json['dailyAverageSpent'] as num?)?.toDouble() ?? 28.50,
      monthlyComparisonPercentage: (json['monthlyComparisonPercentage'] as num?)?.toDouble() ?? -12.4,
      weeklyComparisonPercentage: (json['weeklyComparisonPercentage'] as num?)?.toDouble() ?? -4.2,
      highestCategories: categories,
      lifestyleAnalysis: json['lifestyleAnalysis'] as String? ?? json['summary'] as String? ?? 'Moderate lifestyle with low impulse purchasing.',
      detectedAnomalies: anomalies,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.94,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyAverageSpent': dailyAverageSpent,
      'monthlyComparisonPercentage': monthlyComparisonPercentage,
      'weeklyComparisonPercentage': weeklyComparisonPercentage,
      'highestCategories': highestCategories
          .map((e) => CategorySpendingShareModel(
                categoryName: e.categoryName,
                amount: e.amount,
                percentage: e.percentage,
                trendDirection: e.trendDirection,
              ).toJson())
          .toList(),
      'lifestyleAnalysis': lifestyleAnalysis,
      'detectedAnomalies': detectedAnomalies,
      'confidenceScore': confidenceScore,
    };
  }
}
