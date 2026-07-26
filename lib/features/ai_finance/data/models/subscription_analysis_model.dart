import '../../domain/entities/subscription_analysis.dart';

class SubscriptionItemModel extends SubscriptionItem {
  const SubscriptionItemModel({
    required super.id,
    required super.name,
    required super.cost,
    required super.billingPeriod,
    required super.isUnusedOrRedundant,
    required super.nextRenewalDate,
    required super.category,
  });

  factory SubscriptionItemModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['title'] as String? ?? 'Subscription',
      cost: (json['cost'] as num?)?.toDouble() ?? (json['amount'] as num?)?.toDouble() ?? 0.0,
      billingPeriod: json['billingPeriod'] as String? ?? 'MONTHLY',
      isUnusedOrRedundant: json['isUnusedOrRedundant'] as bool? ?? json['isUnused'] as bool? ?? false,
      nextRenewalDate: json['nextRenewalDate'] != null ? DateTime.parse(json['nextRenewalDate'] as String) : DateTime.now().add(const Duration(days: 14)),
      category: json['category'] as String? ?? 'Streaming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'billingPeriod': billingPeriod,
      'isUnusedOrRedundant': isUnusedOrRedundant,
      'nextRenewalDate': nextRenewalDate.toIso8601String(),
      'category': category,
    };
  }
}

class SubscriptionAnalysisModel extends SubscriptionAnalysis {
  const SubscriptionAnalysisModel({
    required super.totalMonthlySubscriptionCost,
    required super.activeSubscriptionCount,
    required super.unusedCount,
    required super.potentialMonthlySavingsFromCancellation,
    required super.subscriptions,
  });

  factory SubscriptionAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['subscriptions'] as List<dynamic>? ?? [];
    final subs = rawList
        .map((e) => SubscriptionItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SubscriptionAnalysisModel(
      totalMonthlySubscriptionCost: (json['totalMonthlySubscriptionCost'] as num?)?.toDouble() ?? 49.99,
      activeSubscriptionCount: json['activeSubscriptionCount'] as int? ?? subs.length,
      unusedCount: json['unusedCount'] as int? ?? subs.where((s) => s.isUnusedOrRedundant).length,
      potentialMonthlySavingsFromCancellation: (json['potentialMonthlySavingsFromCancellation'] as num?)?.toDouble() ?? 14.99,
      subscriptions: subs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMonthlySubscriptionCost': totalMonthlySubscriptionCost,
      'activeSubscriptionCount': activeSubscriptionCount,
      'unusedCount': unusedCount,
      'potentialMonthlySavingsFromCancellation': potentialMonthlySavingsFromCancellation,
      'subscriptions': subscriptions
          .map((e) => SubscriptionItemModel(
                id: e.id,
                name: e.name,
                cost: e.cost,
                billingPeriod: e.billingPeriod,
                isUnusedOrRedundant: e.isUnusedOrRedundant,
                nextRenewalDate: e.nextRenewalDate,
                category: e.category,
              ).toJson())
          .toList(),
    };
  }
}
