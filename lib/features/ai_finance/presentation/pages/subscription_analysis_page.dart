import 'package:flutter/material.dart';
import '../../domain/entities/subscription_analysis.dart';
import '../widgets/subscription_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class SubscriptionAnalysisPage extends StatefulWidget {
  final SubscriptionAnalysis? analysis;

  const SubscriptionAnalysisPage({super.key, this.analysis});

  @override
  State<SubscriptionAnalysisPage> createState() => _SubscriptionAnalysisPageState();
}

class _SubscriptionAnalysisPageState extends State<SubscriptionAnalysisPage> {
  @override
  void initState() {
    super.initState();
    if (widget.analysis == null) {
      context.read<AIFinanceBloc>().add(const LoadSubscriptionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.analysis != null) {
      return _buildScaffold(context, widget.analysis!);
    }

    return BlocBuilder<AIFinanceBloc, AIFinanceState>(
      builder: (context, state) {
        if (state is AIFinanceLoadingState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Subscription Analysis')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AIFinanceLoadedState) {
          return _buildScaffold(context, state.subscriptions);
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Subscription Analysis')),
          body: const Center(child: Text('No subscription data available.')),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, SubscriptionAnalysis data) {
    final theme = Theme.of(context);
    final hasSubscriptions = data.subscriptions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasSubscriptions) ...[
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
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.subscriptions_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No Subscriptions Detected', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'No recurring subscription expenses detected in your transactions. AI analyzes recurring monthly transactions to identify active services.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
