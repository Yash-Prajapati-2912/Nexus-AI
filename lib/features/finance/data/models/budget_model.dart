import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.name,
    required super.totalLimit,
    required super.currentSpent,
    required super.period,
    required super.startDate,
    required super.endDate,
    super.categoryId,
    super.alertOn80Percent,
    super.alertOn100Percent,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['notes'] as String? ?? json['title'] as String? ?? 'Monthly Budget',
      totalLimit: (json['plannedAmount'] as num?)?.toDouble() ??
          (json['totalLimit'] as num?)?.toDouble() ??
          (json['amount'] as num?)?.toDouble() ??
          0.0,
      currentSpent: (json['spentAmount'] as num?)?.toDouble() ??
          (json['currentSpent'] as num?)?.toDouble() ??
          (json['spent'] as num?)?.toDouble() ??
          0.0,
      period: json['period'] as String? ?? 'MONTHLY',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime(json['year'] as int? ?? DateTime.now().year, json['month'] as int? ?? DateTime.now().month, 1),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime(json['year'] as int? ?? DateTime.now().year, (json['month'] as int? ?? DateTime.now().month) + 1, 0),
      categoryId: json['categoryId'] as String?,
      alertOn80Percent: json['alertOn80Percent'] as bool? ?? true,
      alertOn100Percent: json['alertOn100Percent'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalLimit': totalLimit,
      'currentSpent': currentSpent,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'categoryId': categoryId,
      'alertOn80Percent': alertOn80Percent,
      'alertOn100Percent': alertOn100Percent,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'month': startDate.month,
      'year': startDate.year,
      'plannedAmount': totalLimit,
      'currency': 'INR',
      if (name.isNotEmpty) 'notes': name,
    };
  }

  factory BudgetModel.fromEntity(Budget entity) {
    return BudgetModel(
      id: entity.id,
      name: entity.name,
      totalLimit: entity.totalLimit,
      currentSpent: entity.currentSpent,
      period: entity.period,
      startDate: entity.startDate,
      endDate: entity.endDate,
      categoryId: entity.categoryId,
      alertOn80Percent: entity.alertOn80Percent,
      alertOn100Percent: entity.alertOn100Percent,
    );
  }
}
