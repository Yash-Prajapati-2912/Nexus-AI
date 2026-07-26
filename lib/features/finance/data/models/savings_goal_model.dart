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
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
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
    final rawHistory = json['contributionHistory'] as List<dynamic>? ?? [];
    final history = rawHistory
        .map((e) => ContributionRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SavingsGoalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['name'] as String? ?? 'Savings Goal',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : DateTime.now().add(const Duration(days: 90)),
      iconName: json['iconName'] as String? ?? 'savings',
      colorHex: json['colorHex'] as String? ?? '#10B981',
      contributionHistory: history,
    );
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
}
