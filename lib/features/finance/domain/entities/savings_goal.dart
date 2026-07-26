import 'package:equatable/equatable.dart';

class ContributionRecord extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final String? note;

  const ContributionRecord({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [id, amount, date, note];
}

/// Domain entity for Savings Goal.
class SavingsGoal extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String iconName;
  final String colorHex;
  final List<ContributionRecord> contributionHistory;

  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.iconName = 'savings',
    this.colorHex = '#10B981',
    this.contributionHistory = const [],
  });

  double get progressPercentage => (targetAmount > 0) ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get remainingAmount => targetAmount - currentAmount;
  bool get isAchieved => currentAmount >= targetAmount;

  SavingsGoal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    String? iconName,
    String? colorHex,
    List<ContributionRecord>? contributionHistory,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      contributionHistory: contributionHistory ?? this.contributionHistory,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        targetAmount,
        currentAmount,
        targetDate,
        iconName,
        colorHex,
        contributionHistory,
      ];
}
