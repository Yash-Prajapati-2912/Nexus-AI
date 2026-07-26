import 'package:equatable/equatable.dart';

/// Domain entity representing a Budget target & progress.
class Budget extends Equatable {
  final String id;
  final String name;
  final double totalLimit;
  final double currentSpent;
  final String period; // MONTHLY, WEEKLY, CUSTOM
  final DateTime startDate;
  final DateTime endDate;
  final String? categoryId;
  final bool alertOn80Percent;
  final bool alertOn100Percent;

  const Budget({
    required this.id,
    required this.name,
    required this.totalLimit,
    required this.currentSpent,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.categoryId,
    this.alertOn80Percent = true,
    this.alertOn100Percent = true,
  });

  double get remainingAmount => totalLimit - currentSpent;
  double get spentPercentage => (totalLimit > 0) ? (currentSpent / totalLimit).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => currentSpent > totalLimit;

  Budget copyWith({
    String? id,
    String? name,
    double? totalLimit,
    double? currentSpent,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    bool? alertOn80Percent,
    bool? alertOn100Percent,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      totalLimit: totalLimit ?? this.totalLimit,
      currentSpent: currentSpent ?? this.currentSpent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      alertOn80Percent: alertOn80Percent ?? this.alertOn80Percent,
      alertOn100Percent: alertOn100Percent ?? this.alertOn100Percent,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        totalLimit,
        currentSpent,
        period,
        startDate,
        endDate,
        categoryId,
        alertOn80Percent,
        alertOn100Percent,
      ];
}
