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
    final rawDate = json['receivedDate'] ?? json['date'] ?? json['incomeDate'] ?? json['createdAt'];
    final sourceStr = json['source'] as String? ?? json['title'] as String? ?? 'Income';
    return IncomeModel(
      id: json['id'] as String? ?? '',
      title: sourceStr,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      sourceCategory: json['sourceCategory'] as String? ?? json['category'] as String? ?? sourceStr,
      date: rawDate != null ? (DateTime.tryParse(rawDate.toString())?.toLocal() ?? DateTime.now()) : DateTime.now(),
      note: json['description'] as String? ?? json['note'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPeriod: json['frequency'] as String? ?? json['recurringPeriod'] as String? ?? 'MONTHLY',
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

  Map<String, dynamic> toCreateJson() {
    final sourceName = title.trim().isNotEmpty
        ? title.trim()
        : (sourceCategory.isNotEmpty ? sourceCategory : 'Income');
    final map = <String, dynamic>{
      'source': sourceName,
      'amount': amount,
      'receivedDate': date.toUtc().toIso8601String(),
      'isRecurring': isRecurring,
      'frequency': isRecurring ? normalizeFrequency(recurringPeriod) : 'ONE_TIME',
    };
    if (note != null && note!.trim().isNotEmpty) {
      map['description'] = note!.trim();
    }
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{
      'amount': amount,
      'receivedDate': date.toUtc().toIso8601String(),
      'isRecurring': isRecurring,
      'frequency': isRecurring ? normalizeFrequency(recurringPeriod) : 'ONE_TIME',
    };
    if (title.trim().isNotEmpty) {
      map['source'] = title.trim();
    } else if (sourceCategory.isNotEmpty) {
      map['source'] = sourceCategory;
    }
    if (note != null && note!.trim().isNotEmpty) {
      map['description'] = note!.trim();
    }
    return map;
  }

  static String normalizeFrequency(String? freq) {
    if (freq == null) return 'MONTHLY';
    switch (freq.toUpperCase()) {
      case 'ONE_TIME':
        return 'ONE_TIME';
      case 'WEEKLY':
        return 'WEEKLY';
      case 'BI_WEEKLY':
        return 'BI_WEEKLY';
      case 'YEARLY':
        return 'YEARLY';
      case 'MONTHLY':
      default:
        return 'MONTHLY';
    }
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
