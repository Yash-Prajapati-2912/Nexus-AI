import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.categoryName,
    required super.date,
    super.note,
    super.paymentMethod,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'EXPENSE';
    final isIncome = typeStr.toUpperCase() == 'INCOME';

    return TransactionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['description'] as String? ?? 'Transaction',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: isIncome ? TransactionType.income : TransactionType.expense,
      categoryName: json['categoryName'] as String? ?? 'General',
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      note: json['note'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'INCOME' : 'EXPENSE',
      'categoryName': categoryName,
      'date': date.toIso8601String(),
      'note': note,
      'paymentMethod': paymentMethod,
    };
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      type: entity.type,
      categoryName: entity.categoryName,
      date: entity.date,
      note: entity.note,
      paymentMethod: entity.paymentMethod,
    );
  }
}
