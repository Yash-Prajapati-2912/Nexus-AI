import 'package:equatable/equatable.dart';

class SubscriptionItem extends Equatable {
  final String id;
  final String name;
  final double cost;
  final String billingPeriod; // MONTHLY, YEARLY
  final bool isUnusedOrRedundant;
  final DateTime nextRenewalDate;
  final String category;

  const SubscriptionItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.billingPeriod,
    required this.isUnusedOrRedundant,
    required this.nextRenewalDate,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        cost,
        billingPeriod,
        isUnusedOrRedundant,
        nextRenewalDate,
        category,
      ];
}

/// Domain entity for Subscription Audit & Analysis.
class SubscriptionAnalysis extends Equatable {
  final double totalMonthlySubscriptionCost;
  final int activeSubscriptionCount;
  final int unusedCount;
  final double potentialMonthlySavingsFromCancellation;
  final List<SubscriptionItem> subscriptions;

  const SubscriptionAnalysis({
    required this.totalMonthlySubscriptionCost,
    required this.activeSubscriptionCount,
    required this.unusedCount,
    required this.potentialMonthlySavingsFromCancellation,
    required this.subscriptions,
  });

  @override
  List<Object?> get props => [
        totalMonthlySubscriptionCost,
        activeSubscriptionCount,
        unusedCount,
        potentialMonthlySavingsFromCancellation,
        subscriptions,
      ];
}
