import 'package:flutter/material.dart';
import '../../domain/entities/subscription_analysis.dart';
import '../widgets/subscription_card.dart';

class SubscriptionAnalysisPage extends StatelessWidget {
  final SubscriptionAnalysis? analysis;

  const SubscriptionAnalysisPage({super.key, this.analysis});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final data = analysis ??
        SubscriptionAnalysis(
          totalMonthlySubscriptionCost: 49.99,
          activeSubscriptionCount: 4,
          unusedCount: 1,
          potentialMonthlySavingsFromCancellation: 14.99,
          subscriptions: [
            SubscriptionItem(id: 's1', name: 'Netflix Premium', cost: 19.99, billingPeriod: 'MONTHLY', isUnusedOrRedundant: false, nextRenewalDate: now.add(const Duration(days: 12)), category: 'Streaming'),
            SubscriptionItem(id: 's2', name: 'Spotify Premium', cost: 5.99, billingPeriod: 'MONTHLY', isUnusedOrRedundant: false, nextRenewalDate: now.add(const Duration(days: 18)), category: 'Music'),
            SubscriptionItem(id: 's3', name: 'Unused Cloud Storage', cost: 14.99, billingPeriod: 'MONTHLY', isUnusedOrRedundant: true, nextRenewalDate: now.add(const Duration(days: 4)), category: 'Tech'),
            SubscriptionItem(id: 's4', name: 'Gym Membership', cost: 9.02, billingPeriod: 'MONTHLY', isUnusedOrRedundant: false, nextRenewalDate: now.add(const Duration(days: 25)), category: 'Fitness'),
          ],
        );


    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionCard(analysis: data),
            const SizedBox(height: 20),
            const Text('Active Subscriptions List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...data.subscriptions.map((sub) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      sub.isUnusedOrRedundant ? Icons.warning_rounded : Icons.check_circle_rounded,
                      color: sub.isUnusedOrRedundant ? Colors.redAccent : const Color(0xFF10B981),
                    ),
                    title: Text(sub.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(sub.isUnusedOrRedundant ? 'Flagged as Unused' : 'Active Subscription'),
                    trailing: Text('₹${sub.cost.toStringAsFixed(2)}/mo', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
