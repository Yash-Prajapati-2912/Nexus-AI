import 'package:equatable/equatable.dart';

/// Domain entity representing an Income transaction.
class Income extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String sourceCategory; // SALARY, SCHOLARSHIP, FREELANCE, ALLOWANCE, INVESTMENT
  final DateTime date;
  final String? note;
  final bool isRecurring;
  final String? recurringPeriod;

  const Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.sourceCategory,
    required this.date,
    this.note,
    this.isRecurring = false,
    this.recurringPeriod,
  });

  Income copyWith({
    String? id,
    String? title,
    double? amount,
    String? sourceCategory,
    DateTime? date,
    String? note,
    bool? isRecurring,
    String? recurringPeriod,
  }) {
    return Income(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      sourceCategory: sourceCategory ?? this.sourceCategory,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        sourceCategory,
        date,
        note,
        isRecurring,
        recurringPeriod,
      ];
}
