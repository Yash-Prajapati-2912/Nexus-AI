import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.categoryId,
    required super.categoryName,
    required super.categoryIcon,
    required super.date,
    super.note,
    super.receiptUrl,
    super.isRecurring,
    super.recurringPeriod,
    super.tags,
    super.status,
    super.paymentMethod,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>? ?? [];
    final tags = rawTags.map((e) => e.toString()).toList();

    final categoryObj = json['category'] as Map<String, dynamic>?;
    final rawDate = json['date'] ?? json['expenseDate'] ?? json['createdAt'];

    return ExpenseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? json['description'] as String? ?? 'Expense',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] as String? ?? categoryObj?['id'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? categoryObj?['name'] as String? ?? 'General',
      categoryIcon: json['categoryIcon'] as String? ?? categoryObj?['iconName'] as String? ?? 'receipt',
      date: rawDate != null ? (DateTime.tryParse(rawDate.toString()) ?? DateTime.now()) : DateTime.now(),
      note: json['note'] as String? ?? json['description'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPeriod: json['recurringPeriod'] as String?,
      tags: tags,
      status: json['status'] as String? ?? 'COMPLETED',
      paymentMethod: json['paymentMethod'] as String? ?? 'CARD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'date': date.toIso8601String(),
      'note': note,
      'receiptUrl': receiptUrl,
      'isRecurring': isRecurring,
      'recurringPeriod': recurringPeriod,
      'tags': tags,
      'status': status,
      'paymentMethod': _normalizePaymentMethod(paymentMethod),
    };
  }

  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{
      'title': title.trim(),
      'amount': amount,
      'categoryId': categoryId,
      'expenseDate': date.toIso8601String(),
      'paymentMethod': _normalizePaymentMethod(paymentMethod),
      'isRecurring': isRecurring,
    };
    if (note != null && note!.trim().isNotEmpty) {
      map['notes'] = note!.trim();
      map['description'] = note!.trim();
    }
    if (receiptUrl != null && receiptUrl!.trim().isNotEmpty) {
      map['receiptUrl'] = receiptUrl;
    }
    if (tags.isNotEmpty) {
      map['tags'] = tags;
    }
    return map;
  }

  static String _normalizePaymentMethod(String pm) {
    switch (pm.toUpperCase()) {
      case 'CARD':
      case 'CREDIT_CARD':
        return 'CREDIT_CARD';
      case 'DEBIT_CARD':
        return 'DEBIT_CARD';
      case 'CASH':
        return 'CASH';
      case 'UPI':
        return 'UPI';
      case 'BANK_TRANSFER':
        return 'BANK_TRANSFER';
      case 'OTHER':
      default:
        return 'DEBIT_CARD';
    }
  }

  factory ExpenseModel.fromEntity(Expense entity) {
    return ExpenseModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      categoryIcon: entity.categoryIcon,
      date: entity.date,
      note: entity.note,
      receiptUrl: entity.receiptUrl,
      isRecurring: entity.isRecurring,
      recurringPeriod: entity.recurringPeriod,
      tags: entity.tags,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
    );
  }
}
