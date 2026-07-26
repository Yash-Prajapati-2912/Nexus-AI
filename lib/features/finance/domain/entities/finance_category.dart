import 'package:equatable/equatable.dart';

/// Domain entity for Financial Category.
class FinanceCategory extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final String type; // EXPENSE, INCOME
  final double? monthlyBudgetLimit;

  const FinanceCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.type,
    this.monthlyBudgetLimit,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        iconName,
        colorHex,
        type,
        monthlyBudgetLimit,
      ];
}
