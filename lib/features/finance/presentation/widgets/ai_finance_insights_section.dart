import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/savings_goal.dart';

class AIFinanceInsightsSection extends StatelessWidget {
  final List<Expense> expenses;
  final List<Budget> budgets;
  final List<SavingsGoal> savingsGoals;
  final String currencySymbol;

  const AIFinanceInsightsSection({
    super.key,
    required this.expenses,
    required this.budgets,
    required this.savingsGoals,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final insights = _generateDataDrivenInsights();

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 8),
            const Text('AI Financial Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...insights.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark
                      ? const Color(0xFF1E1E2E)
                      : Colors.white,
                  border: Border.all(
                    color: item.badgeColor.withAlpha(80),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item.badgeColor.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.badgeColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.badgeColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: item.onTapAction != null ? () => item.onTapAction!(context) : null,
                      child: Text(item.actionLabel),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  List<_InsightData> _generateDataDrivenInsights() {
    final list = <_InsightData>[];

    // Check budget warnings/exceeded
    for (var b in budgets) {
      if (b.isOverBudget) {
        list.add(_InsightData(
          icon: Icons.warning_amber_rounded,
          badgeColor: Colors.redAccent,
          title: 'Budget Exceeded',
          message: '${b.name} has exceeded its target limit by $currencySymbol${(b.currentSpent - b.totalLimit).toStringAsFixed(0)}.',
          actionLabel: 'Review',
          onTapAction: (ctx) => ctx.push(RouteNames.financeBudgets),
        ));
      } else if (b.spentPercentage >= 0.85) {
        list.add(_InsightData(
          icon: Icons.error_outline_rounded,
          badgeColor: Colors.amber,
          title: 'Budget Alert',
          message: '${b.name} has reached ${(b.spentPercentage * 100).toStringAsFixed(0)}% of your monthly limit.',
          actionLabel: 'Review',
          onTapAction: (ctx) => ctx.push(RouteNames.financeBudgets),
        ));
      }
    }

    // Check savings goal progress
    for (var g in savingsGoals) {
      if (g.progressPercentage > 0 && g.progressPercentage < 1.0) {
        list.add(_InsightData(
          icon: Icons.savings_rounded,
          badgeColor: const Color(0xFF10B981),
          title: 'Savings Insight',
          message: '${g.title} is at ${(g.progressPercentage * 100).toStringAsFixed(0)}%. Saving ${currencySymbol}1,000 more per month reaches your target faster.',
          actionLabel: 'View Goal',
          onTapAction: (ctx) => ctx.push(RouteNames.financeSavings),
        ));
        break;
      }
    }

    // Default contextual optimization insight if list is short
    if (list.length < 2) {
      list.add(_InsightData(
        icon: Icons.auto_graph_rounded,
        badgeColor: const Color(0xFF8B5CF6),
        title: 'Smart Cash-Flow Insight',
        message: 'Your safe daily spending cap helps protect your net savings for month-end.',
        actionLabel: 'Analyze',
        onTapAction: (ctx) => ctx.push(RouteNames.aiFinanceSpendingInsights),
      ));
    }

    return list.take(3).toList();
  }
}

class _InsightData {
  final IconData icon;
  final Color badgeColor;
  final String title;
  final String message;
  final String actionLabel;
  final Function(BuildContext context)? onTapAction;

  _InsightData({
    required this.icon,
    required this.badgeColor,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onTapAction,
  });
}
