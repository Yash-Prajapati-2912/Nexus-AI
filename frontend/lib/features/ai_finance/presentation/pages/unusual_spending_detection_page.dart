import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class UnusualSpendingDetectionPage extends StatefulWidget {
  const UnusualSpendingDetectionPage({super.key});

  @override
  State<UnusualSpendingDetectionPage> createState() => _UnusualSpendingDetectionPageState();
}

class _UnusualSpendingDetectionPageState extends State<UnusualSpendingDetectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<AIFinanceBloc>().add(const LoadInsightsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Unusual Spending Anomaly')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AIFinanceLoadedState) {
            final anomalies = state.insight.detectedAnomalies;

            if (anomalies.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
                      const SizedBox(height: 16),
                      Text('No Spending Anomalies', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                        'All recorded transactions conform to your normal spending patterns. AI monitors for unexpected price spikes or recurring charge changes.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: anomalies.length,
              itemBuilder: (context, index) {
                final anomaly = anomalies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 24),
                            const SizedBox(width: 8),
                            Text('Spending Anomaly Detected', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(anomaly, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No spending anomaly data available.'));
        },
      ),
    );
  }
}
