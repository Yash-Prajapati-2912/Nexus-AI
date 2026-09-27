import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/finance_summary_entity.dart';

class FinanceSummaryWidget extends StatelessWidget {
  final FinanceSummaryEntity summary;

  const FinanceSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spent = summary.spentThisMonth;
    final budget = summary.monthlyBudget > 0 ? summary.monthlyBudget : (spent + summary.remainingBudget);
    final remaining = summary.remainingBudget > 0 ? summary.remainingBudget : (budget - spent);
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 20,
                    color: DesignColors.secondaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Smart Finance Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push(RouteNames.finance),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'Finance Hub',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.secondaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: DesignColors.secondaryDark),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Spending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${spent.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                          fontFamily: 'Poppins',
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (remaining >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          remaining >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          size: 14,
                          color: remaining >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₹${remaining.abs().toStringAsFixed(0)} ${remaining >= 0 ? "Left" : "Over"}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: remaining >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Budget Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.9
                        ? DesignColors.errorDark
                        : progress > 0.7
                            ? const Color(0xFFF59E0B)
                            : DesignColors.secondaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildSubStat(
                      context,
                      label: 'Planned Budget',
                      value: '₹${budget.toStringAsFixed(0)}',
                      isDark: isDark,
                    ),
                  ),
                  Expanded(
                    child: _buildSubStat(
                      context,
                      label: "Today's Spent",
                      value: '₹${summary.todayExpenses.toStringAsFixed(0)}',
                      isDark: isDark,
                    ),
                  ),
                  Expanded(
                    child: _buildSubStat(
                      context,
                      label: 'Savings Progress',
                      value: '${summary.savingsGoalProgress.toStringAsFixed(0)}%',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              if (summary.aiFinancialTip != null && summary.aiFinancialTip!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.tips_and_updates_rounded, size: 16, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        summary.aiFinancialTip!,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubStat(
    BuildContext context, {
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : DesignColors.textPrimaryLight,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
