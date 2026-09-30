import '../../domain/entities/savings_goal.dart';

class ContributionRecordModel extends ContributionRecord {
  const ContributionRecordModel({
    required super.id,
    required super.amount,
    required super.date,
    super.note,
  });

  factory ContributionRecordModel.fromJson(Map<String, dynamic> json) {
    return ContributionRecordModel(
      id: json['id'] as String? ?? '',
      amount: _parseDouble(json['amount']),
      date: _parseDate(json['date'] ?? json['createdAt']),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}

class SavingsGoalModel extends SavingsGoal {
  const SavingsGoalModel({
    required super.id,
    required super.title,
    required super.targetAmount,
    required super.currentAmount,
    required super.targetDate,
    super.iconName,
    super.colorHex,
    super.contributionHistory,
  });

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    final rawHistory = (json['contributionHistory'] ?? json['contributions']) as List<dynamic>? ?? [];
    final history = rawHistory
        .whereType<Map<String, dynamic>>()
        .map((e) => ContributionRecordModel.fromJson(e))
        .toList();

    return SavingsGoalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String? ?? 'Savings Goal',
      targetAmount: _parseDouble(json['targetAmount'] ?? json['target_amount']),
      currentAmount: _parseDouble(json['currentAmount'] ?? json['current_amount']),
      targetDate: _parseDate(json['targetDate'] ?? json['target_date']),
      iconName: json['iconName'] as String? ?? json['icon_name'] as String? ?? 'savings',
      colorHex: json['colorHex'] as String? ?? json['color_hex'] as String? ?? '#10B981',
      contributionHistory: history,
    );
  }

  /// Clean payload for creating a savings goal on the backend.
  /// Omits client-generated ID and contribution history to satisfy backend DTO whitelist.
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }

  /// Clean payload for updating a savings goal on the backend.
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'iconName': iconName,
      'colorHex': colorHex,
      'contributionHistory': contributionHistory
          .map((e) => ContributionRecordModel(
                id: e.id,
                amount: e.amount,
                date: e.date,
                note: e.note,
              ).toJson())
          .toList(),
    };
  }

  factory SavingsGoalModel.fromEntity(SavingsGoal entity) {
    return SavingsGoalModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      currentAmount: entity.currentAmount,
      targetDate: entity.targetDate,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      contributionHistory: entity.contributionHistory,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now().add(const Duration(days: 90));
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now().add(const Duration(days: 90));
    return DateTime.now().add(const Duration(days: 90));
  }
}
