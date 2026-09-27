import 'package:equatable/equatable.dart';

/// Domain entity representing a user-tracked investment asset.
class Investment extends Equatable {
  final String id;
  final String name;
  final String assetType; // MUTUAL_FUND, STOCKS, FIXED_DEPOSIT, GOLD, CRYPTO, OTHER
  final double investedAmount;
  final double currentValue;
  final DateTime date;
  final String? notes;

  const Investment({
    required this.id,
    required this.name,
    required this.assetType,
    required this.investedAmount,
    required this.currentValue,
    required this.date,
    this.notes,
  });

  double get gainLoss => currentValue - investedAmount;

  double get gainLossPercentage =>
      investedAmount > 0 ? ((currentValue - investedAmount) / investedAmount) * 100 : 0.0;

  double get gainLossPct => gainLossPercentage;

  bool get isProfit => currentValue >= investedAmount;

  Investment copyWith({
    String? id,
    String? name,
    String? assetType,
    double? investedAmount,
    double? currentValue,
    DateTime? date,
    String? notes,
  }) {
    return Investment(
      id: id ?? this.id,
      name: name ?? this.name,
      assetType: assetType ?? this.assetType,
      investedAmount: investedAmount ?? this.investedAmount,
      currentValue: currentValue ?? this.currentValue,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        assetType,
        investedAmount,
        currentValue,
        date,
        notes,
      ];
}
