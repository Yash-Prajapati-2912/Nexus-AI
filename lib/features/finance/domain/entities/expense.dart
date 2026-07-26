import 'package:equatable/equatable.dart';

/// Domain entity representing an Expense transaction.
class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final DateTime date;
  final String? note;
  final String? receiptUrl;
  final bool isRecurring;
  final String? recurringPeriod; // DAILY, WEEKLY, MONTHLY, YEARLY
  final List<String> tags;
  final String status; // COMPLETED, PENDING, CANCELLED
  final String paymentMethod; // CASH, CARD, UPI, BANK_TRANSFER

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.date,
    this.note,
    this.receiptUrl,
    this.isRecurring = false,
    this.recurringPeriod,
    this.tags = const [],
    this.status = 'COMPLETED',
    this.paymentMethod = 'CARD',
  });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    DateTime? date,
    String? note,
    String? receiptUrl,
    bool? isRecurring,
    String? recurringPeriod,
    List<String>? tags,
    String? status,
    String? paymentMethod,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      date: date ?? this.date,
      note: note ?? this.note,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        categoryId,
        categoryName,
        categoryIcon,
        date,
        note,
        receiptUrl,
        isRecurring,
        recurringPeriod,
        tags,
        status,
        paymentMethod,
      ];
}
