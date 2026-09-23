import '../../domain/entities/budget_recommendation.dart';

class CategoryBudgetAdjustmentModel extends CategoryBudgetAdjustment {
  const CategoryBudgetAdjustmentModel({
    required super.categoryName,
    required super.currentLimit,
    required super.recommendedLimit,
    required super.reasoning,
  });

  factory CategoryBudgetAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return CategoryBudgetAdjustmentModel(
      categoryName: json['categoryName'] as String? ?? json['category'] as String? ?? 'General',
      currentLimit: (json['currentLimit'] as num?)?.toDouble() ?? 0.0,
      recommendedLimit: (json['recommendedLimit'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning'] as String? ?? 'Optimized based on average usage.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'currentLimit': currentLimit,
      'recommendedLimit': recommendedLimit,
      'reasoning': reasoning,
    };
  }
}

class BudgetRecommendationModel extends BudgetRecommendation {
  const BudgetRecommendationModel({
    required super.safeDailySpendingLimit,
    required super.recommendedTotalMonthlyBudget,
    required super.categoryAdjustments,
    required super.optimizationStrategy,
  });

  factory BudgetRecommendationModel.fromJson(Map<String, dynamic> json) {
    final rawAdjs = json['categoryAdjustments'] as List<dynamic>? ?? [];
    final adjs = rawAdjs
        .map((e) => CategoryBudgetAdjustmentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return BudgetRecommendationModel(
      safeDailySpendingLimit: (json['safeDailySpendingLimit'] as num?)?.toDouble() ?? (json['safeDailyBudget'] as num?)?.toDouble() ?? 32.50,
      recommendedTotalMonthlyBudget: (json['recommendedTotalMonthlyBudget'] as num?)?.toDouble() ?? 950.00,
      categoryAdjustments: adjs,
      optimizationStrategy: json['optimizationStrategy'] as String? ?? json['strategy'] as String? ?? 'Reallocate ₹500 from Entertainment to Savings.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'safeDailySpendingLimit': safeDailySpendingLimit,
      'recommendedTotalMonthlyBudget': recommendedTotalMonthlyBudget,
      'categoryAdjustments': categoryAdjustments
          .map((e) => CategoryBudgetAdjustmentModel(
                categoryName: e.categoryName,
                currentLimit: e.currentLimit,
                recommendedLimit: e.recommendedLimit,
                reasoning: e.reasoning,
              ).toJson())
          .toList(),
      'optimizationStrategy': optimizationStrategy,
    };
  }
}
