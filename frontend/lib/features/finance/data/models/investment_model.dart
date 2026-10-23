import '../../domain/entities/investment.dart';

class InvestmentModel {
  final String id;
  final String name;
  final String assetType;
  final double investedAmount;
  final double currentValue;
  final String date;
  final String? notes;

  const InvestmentModel({
    required this.id,
    required this.name,
    required this.assetType,
    required this.investedAmount,
    required this.currentValue,
    required this.date,
    this.notes,
  });

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Investment',
      assetType: json['assetType'] as String? ?? 'OTHER',
      investedAmount: _parseDouble(json['investedAmount'] ?? json['amount']),
      currentValue: _parseDouble(json['currentValue'] ?? json['investedAmount'] ?? json['amount']),
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'assetType': assetType,
        'investedAmount': investedAmount,
        'currentValue': currentValue,
        'date': date,
        'notes': notes,
      };

  Investment toDomain() {
    return Investment(
      id: id,
      name: name,
      assetType: assetType,
      investedAmount: investedAmount,
      currentValue: currentValue,
      date: DateTime.tryParse(date) ?? DateTime.now(),
      notes: notes,
    );
  }

  factory InvestmentModel.fromDomain(Investment investment) {
    return InvestmentModel(
      id: investment.id,
      name: investment.name,
      assetType: investment.assetType,
      investedAmount: investment.investedAmount,
      currentValue: investment.currentValue,
      date: investment.date.toIso8601String(),
      notes: investment.notes,
    );
  }
}
