import 'package:flutter/material.dart';

class TransparentFinancialHealthCard extends StatefulWidget {
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalBudget;
  final double currentSpent;
  final double savingsProgressPct;

  const TransparentFinancialHealthCard({
    super.key,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.totalBudget,
    required this.currentSpent,
    required this.savingsProgressPct,
  });

  @override
  State<TransparentFinancialHealthCard> createState() => _TransparentFinancialHealthCardState();
}

class _TransparentFinancialHealthCardState extends State<TransparentFinancialHealthCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate transparent score breakdown
    // 1. Budget Adherence (40 points)
    final budgetPct = (widget.totalBudget > 0) ? (widget.currentSpent / widget.totalBudget) : 0.0;
    final double budgetAdherenceScore = (budgetPct <= 1.0) ? (1.0 - budgetPct) * 40.0 : 0.0;

    // 2. Savings Rate (30 points)
    final savingsRate = (widget.monthlyIncome > 0) ? ((widget.monthlyIncome - widget.monthlyExpense) / widget.monthlyIncome) : 0.0;
    final double savingsRateScore = (savingsRate.clamp(0.0, 1.0)) * 30.0;

    // 3. Expense Stability (20 points)
    final double expenseRatio = (widget.monthlyIncome > 0) ? (widget.monthlyExpense / widget.monthlyIncome) : 0.0;
    final double expenseStabilityScore = (expenseRatio <= 0.8) ? 20.0 : ((1.0 - expenseRatio.clamp(0.0, 1.0)) / 0.2) * 20.0;

    // 4. Goal Progress (10 points)
    final double goalScore = (widget.savingsProgressPct.clamp(0.0, 1.0)) * 10.0;

    final overallScore = (budgetAdherenceScore + savingsRateScore + expenseStabilityScore + goalScore).round().clamp(0, 100);

    Color scoreColor;
    String rating;
    if (overallScore >= 80) {
      scoreColor = const Color(0xFF10B981);
      rating = 'Excellent';
    } else if (overallScore >= 60) {
      scoreColor = Colors.amber;
      rating = 'Good';
    } else if (overallScore >= 40) {
      scoreColor = Colors.orangeAccent;
      rating = 'Fair';
    } else {
      scoreColor = Colors.redAccent;
      rating = 'Needs Attention';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: scoreColor.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: scoreColor.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.health_and_safety_rounded, color: scoreColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Financial Health Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Transparent adherence calculation', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scoreColor.withAlpha(35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$overallScore / 100 • $rating',
                      style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: overallScore / 100.0,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                _ScoreFactorRow(label: 'Budget Adherence (40%)', points: budgetAdherenceScore, maxPoints: 40),
                const SizedBox(height: 6),
                _ScoreFactorRow(label: 'Savings Rate (30%)', points: savingsRateScore, maxPoints: 30),
                const SizedBox(height: 6),
                _ScoreFactorRow(label: 'Expense Stability (20%)', points: expenseStabilityScore, maxPoints: 20),
                const SizedBox(height: 6),
                _ScoreFactorRow(label: 'Goal Progress (10%)', points: goalScore, maxPoints: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreFactorRow extends StatelessWidget {
  final String label;
  final double points;
  final double maxPoints;

  const _ScoreFactorRow({required this.label, required this.points, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          '${points.round()} / ${maxPoints.toInt()} pts',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
