import '../../domain/entities/income.dart';

class IncomeModel extends Income {
  const IncomeModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.sourceCategory,
    required super.date,
    super.note,
    super.isRecurring,
    super.recurringPeriod,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] ?? json['incomeDate'] ?? json['createdAt'];
    return IncomeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['description'] as String? ?? 'Income',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      sourceCategory: json['sourceCategory'] as String? ?? json['category'] as String? ?? 'SALARY',
      date: rawDate != null ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()) : DateTime.now(),
      note: json['note'] as String? ?? json['description'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPeriod: json['recurringPeriod'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'sourceCategory': sourceCategory,
      'date': date.toIso8601String(),
      'note': note,
      'isRecurring': isRecurring,
      'recurringPeriod': recurringPeriod,
    };
  }

  factory IncomeModel.fromEntity(Income entity) {
    return IncomeModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      sourceCategory: entity.sourceCategory,
      date: entity.date,
      note: entity.note,
      isRecurring: entity.isRecurring,
      recurringPeriod: entity.recurringPeriod,
    );
  }
}
