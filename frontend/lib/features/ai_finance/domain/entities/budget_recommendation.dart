import 'package:equatable/equatable.dart';

class CategoryBudgetAdjustment extends Equatable {
  final String categoryName;
  final double currentLimit;
  final double recommendedLimit;
  final String reasoning;

  const CategoryBudgetAdjustment({
    required this.categoryName,
    required this.currentLimit,
    required this.recommendedLimit,
    required this.reasoning,
  });

  @override
  List<Object?> get props => [categoryName, currentLimit, recommendedLimit, reasoning];
}

/// Domain entity for AI Budget Optimization.
class BudgetRecommendation extends Equatable {
  final double safeDailySpendingLimit;
  final double recommendedTotalMonthlyBudget;
  final List<CategoryBudgetAdjustment> categoryAdjustments;
  final String optimizationStrategy;

  const BudgetRecommendation({
    required this.safeDailySpendingLimit,
    required this.recommendedTotalMonthlyBudget,
    required this.categoryAdjustments,
    required this.optimizationStrategy,
  });

  @override
  List<Object?> get props => [
        safeDailySpendingLimit,
        recommendedTotalMonthlyBudget,
        categoryAdjustments,
        optimizationStrategy,
      ];
}
