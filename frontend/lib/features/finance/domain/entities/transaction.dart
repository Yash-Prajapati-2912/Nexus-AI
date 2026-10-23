import 'package:equatable/equatable.dart';

enum TransactionType { expense, income }

/// Domain entity for a unified Transaction (Expense + Income).
class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryName;
  final DateTime date;
  final String? note;
  final String? paymentMethod;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryName,
    required this.date,
    this.note,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        categoryName,
        date,
        note,
        paymentMethod,
      ];
}
