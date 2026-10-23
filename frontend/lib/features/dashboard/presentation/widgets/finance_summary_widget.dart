import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../../domain/entities/finance_summary_entity.dart';

class FinanceSummaryWidget extends StatelessWidget {
  final FinanceSummaryEntity summary;

  const FinanceSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isBrandNewUser = summary.totalIncome == 0 &&
        summary.spentThisMonth == 0 &&
        summary.monthlyBudget == 0 &&
        summary.recentTransactions.isEmpty &&
        (summary.activeGoalTitle == null || summary.activeGoalTitle!.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildHeader(context, isDark),
        const SizedBox(height: 12),

        // Main Card
        isBrandNewUser
            ? _buildEmptyStateCard(context, isDark)
            : _buildActiveFinanceCard(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: DesignColors.secondaryDark.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 18,
                  color: DesignColors.secondaryDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Finance Overview',
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
          onPressed: () async {
            await context.push(RouteNames.finance);
            if (context.mounted) {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: DesignColors.secondaryDark.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: DesignColors.secondaryDark,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start Tracking Your Finances',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Log your first income or expense to see real-time cash flow, budget health, and savings progress.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  await context.push(RouteNames.financeAddIncome);
                  if (context.mounted) {
                    context.read<DashboardBloc>().add(RefreshDashboardEvent());
                  }
                },
                icon: const Icon(Icons.arrow_downward_rounded, size: 14, color: DesignColors.positiveGreenDark),
                label: const Text(
                  'Add Income',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : DesignColors.textPrimaryLight,
                  side: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              FilledButton.icon(
                onPressed: () async {
                  await context.push(RouteNames.financeAddExpense);
                  if (context.mounted) {
                    context.read<DashboardBloc>().add(RefreshDashboardEvent());
                  }
                },
                icon: const Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
                label: const Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: DesignColors.secondaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFinanceCard(BuildContext context, bool isDark) {
    final netBalance = summary.netBalance;
    final isSurplus = netBalance > 0;
    final isDeficit = netBalance < 0;

    final badgeColor = isSurplus
        ? DesignColors.positiveGreenDark
        : isDeficit
            ? DesignColors.errorDark
            : DesignColors.secondaryDark;

    final badgeLabel = isSurplus
        ? 'Surplus'
        : isDeficit
            ? 'Deficit'
            : 'Balanced';

    final badgeIcon = isSurplus
        ? Icons.trending_up_rounded
        : isDeficit
            ? Icons.trending_down_rounded
            : Icons.balance_rounded;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. PRIMARY: Net Balance Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: isDark ? 0.08 : 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Balance',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badgeIcon, size: 13, color: badgeColor),
                          const SizedBox(width: 4),
                          Text(
                            badgeLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${isSurplus ? "+" : isDeficit ? "-" : ""}₹${netBalance.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSurplus
                      ? 'Income exceeds expenses by ₹${netBalance.abs().toStringAsFixed(0)} this month.'
                      : isDeficit
                          ? 'Spending exceeds income by ₹${netBalance.abs().toStringAsFixed(0)} this month.'
                          : 'Income and expenses are evenly matched this month.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. SECONDARY: Income and Expenses Micro-Cards
          Row(
            children: [
              Expanded(
                child: _buildCashFlowMetric(
                  context,
                  title: 'Income',
                  amount: summary.totalIncome,
                  icon: Icons.arrow_downward_rounded,
                  iconColor: DesignColors.positiveGreenDark,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCashFlowMetric(
                  context,
                  title: 'Expenses',
                  amount: summary.spentThisMonth,
                  icon: Icons.arrow_upward_rounded,
                  iconColor: const Color(0xFFF97316),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. SUPPORTING: Budget Health
          _buildBudgetSection(context, isDark),
          const SizedBox(height: 14),

          // 4. SUPPORTING: Savings Goal Progress
          _buildSavingsSection(context, isDark),

          // 5. SUPPORTING: Recent Transactions
          if (summary.recentTransactions.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildRecentTransactionsSection(context, isDark),
          ],

          // Quick Action Footer
          const SizedBox(height: 14),
          _buildQuickActionButtons(context, isDark),
        ],
      ),
    );
  }

  Widget _buildCashFlowMetric(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSection(BuildContext context, bool isDark) {
    final budget = summary.monthlyBudget;
    final spent = summary.spentThisMonth;
    final remaining = summary.remainingBudget;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final usagePct = budget > 0 ? (spent / budget * 100).round() : 0;

    if (budget <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 15,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No monthly budget set',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                await context.push(RouteNames.financeBudgets);
                if (context.mounted) {
                  context.read<DashboardBloc>().add(RefreshDashboardEvent());
                }
              },
              child: const Text(
                'Set Budget',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: DesignColors.secondaryDark,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final isOverBudget = remaining < 0 || spent > budget;
    final progressColor = isOverBudget
        ? DesignColors.errorDark
        : progress > 0.85
            ? const Color(0xFFF59E0B)
            : DesignColors.secondaryDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget Health',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              isOverBudget ? '$usagePct% (Over)' : '$usagePct% Used',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: progressColor,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Budget: ₹${budget.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  'Spent: ₹${spent.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  remaining >= 0 ? 'Left: ₹${remaining.toStringAsFixed(0)}' : 'Over: ₹${remaining.abs().toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: remaining >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsSection(BuildContext context, bool isDark) {
    final title = summary.activeGoalTitle;
    final target = summary.activeGoalTarget;
    final current = summary.activeGoalCurrent;
    final hasGoal = title != null && title.isNotEmpty && target > 0;

    if (!hasGoal) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 15,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No savings goal yet',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                await context.push(RouteNames.financeCreateSavingsGoal);
                if (context.mounted) {
                  context.read<DashboardBloc>().add(RefreshDashboardEvent());
                }
              },
              child: const Text(
                'Create Goal',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: DesignColors.secondaryDark,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final progressRatio = (current / target).clamp(0.0, 1.0);
    final progressPct = (progressRatio * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded, size: 14, color: DesignColors.secondaryDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$progressPct%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: DesignColors.secondaryDark,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progressRatio,
            minHeight: 6,
            backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            valueColor: const AlwaysStoppedAnimation<Color>(DesignColors.secondaryDark),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '₹${current.toStringAsFixed(0)} saved',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Goal: ₹${target.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                fontFamily: 'Poppins',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        ...summary.recentTransactions.take(3).map((tx) {
          final color = _parseColor(tx.categoryColour);
          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tx.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${tx.isExpense ? "-" : "+"}₹${tx.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tx.isExpense
                        ? (isDark ? Colors.white70 : DesignColors.textPrimaryLight)
                        : DesignColors.positiveGreenDark,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickActionButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await context.push(RouteNames.financeAddIncome);
              if (context.mounted) {
                context.read<DashboardBloc>().add(RefreshDashboardEvent());
              }
            },
            icon: const Icon(Icons.arrow_downward_rounded, size: 14, color: DesignColors.positiveGreenDark),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Add Income',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : DesignColors.textPrimaryLight,
              side: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await context.push(RouteNames.financeAddExpense);
              if (context.mounted) {
                context.read<DashboardBloc>().add(RefreshDashboardEvent());
              }
            },
            icon: const Icon(Icons.arrow_upward_rounded, size: 14, color: Color(0xFFF97316)),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Add Expense',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : DesignColors.textPrimaryLight,
              side: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12)),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return DesignColors.secondaryDark;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return DesignColors.secondaryDark;
    }
  }
}
