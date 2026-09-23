import '../../domain/entities/finance_category.dart';

class FinanceCategoryModel extends FinanceCategory {
  const FinanceCategoryModel({
    required super.id,
    required super.name,
    required super.iconName,
    required super.colorHex,
    required super.type,
    super.monthlyBudgetLimit,
  });

  factory FinanceCategoryModel.fromJson(Map<String, dynamic> json) {
    return FinanceCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Category',
      iconName: json['iconName'] as String? ?? json['icon'] as String? ?? 'category',
      colorHex: json['colorHex'] as String? ?? json['color'] as String? ?? '#6366F1',
      type: json['type'] as String? ?? 'EXPENSE',
      monthlyBudgetLimit: (json['monthlyBudgetLimit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'type': type,
      'monthlyBudgetLimit': monthlyBudgetLimit,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name.trim(),
      'colour': colorHex,
      'icon': iconName,
      if (monthlyBudgetLimit != null) 'monthlyLimit': monthlyBudgetLimit,
    };
  }

  factory FinanceCategoryModel.fromEntity(FinanceCategory entity) {
    return FinanceCategoryModel(
      id: entity.id,
      name: entity.name,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      type: entity.type,
      monthlyBudgetLimit: entity.monthlyBudgetLimit,
    );
  }
}
