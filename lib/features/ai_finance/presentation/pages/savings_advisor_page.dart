import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/savings_recommendation.dart';
import '../bloc/ai_finance_bloc.dart';
import '../bloc/ai_finance_event.dart';
import '../bloc/ai_finance_state.dart';

class SavingsAdvisorPage extends StatefulWidget {
  final SavingsRecommendation? savings;

  const SavingsAdvisorPage({super.key, this.savings});

  @override
  State<SavingsAdvisorPage> createState() => _SavingsAdvisorPageState();
}

class _SavingsAdvisorPageState extends State<SavingsAdvisorPage> {
  @override
  void initState() {
    super.initState();
    if (widget.savings == null) {
      context.read<AIFinanceBloc>().add(const LoadFinancialHealthEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Advisor')),
      body: BlocBuilder<AIFinanceBloc, AIFinanceState>(
        builder: (context, state) {
          if (widget.savings == null && state is AIFinanceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = widget.savings ??
              (state is AIFinanceLoadedState
                  ? state.savingsRec
                  : const SavingsRecommendation(
                      totalPotentialMonthlySavings: 0.0,
                      tips: [],
                      aiStrategySummary: 'No savings advice available.',
                    ));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: const Color(0xFF10B981).withAlpha(30),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.savings_rounded, color: Color(0xFF10B981), size: 36),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Potential Savings', style: theme.textTheme.labelMedium),
                              Text(
                                '+₹${data.totalPotentialMonthlySavings.toStringAsFixed(0)}/month',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                              if (data.aiStrategySummary.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  data.aiStrategySummary,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Actionable Savings Tips', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (data.tips.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No specific savings tips generated yet. Log income and expenses to unlock tips.',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  )
                else
                  ...data.tips.map((tip) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${tip.actionableAdvice}\nDifficulty: ${tip.difficultyLevel}'),
                          trailing: Text(
                            tip.potentialMonthlySavings > 0
                                ? '+₹${tip.potentialMonthlySavings.toStringAsFixed(0)}/mo'
                                : 'Insight',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                          ),
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}
