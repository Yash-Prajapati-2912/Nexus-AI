import 'package:equatable/equatable.dart';

class CategorySpendingShare extends Equatable {
  final String categoryName;
  final double amount;
  final double percentage;
  final String trendDirection; // INCREASING, DECREASING, STABLE

  const CategorySpendingShare({
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.trendDirection,
  });

  @override
  List<Object?> get props => [categoryName, amount, percentage, trendDirection];
}

/// Domain entity for AI Spending Insights.
class SpendingInsight extends Equatable {
  final double dailyAverageSpent;
  final double monthlyComparisonPercentage; // e.g. -12.5% vs last month
  final double weeklyComparisonPercentage;
  final List<CategorySpendingShare> highestCategories;
  final String lifestyleAnalysis;
  final List<String> detectedAnomalies;
  final double confidenceScore;

  const SpendingInsight({
    required this.dailyAverageSpent,
    required this.monthlyComparisonPercentage,
    required this.weeklyComparisonPercentage,
    required this.highestCategories,
    required this.lifestyleAnalysis,
    required this.detectedAnomalies,
    required this.confidenceScore,
  });

  @override
  List<Object?> get props => [
        dailyAverageSpent,
        monthlyComparisonPercentage,
        weeklyComparisonPercentage,
        highestCategories,
        lifestyleAnalysis,
        detectedAnomalies,
        confidenceScore,
      ];
}
