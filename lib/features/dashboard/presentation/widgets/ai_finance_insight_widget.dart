import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../domain/entities/finance_summary_entity.dart';

/// Compact AI Finance Insight Card for the Main Dashboard.
///
/// Provides ONE useful real-data financial insight based strictly on
/// the user's actual finance figures (no hallucinated numbers or fake advice).
/// Serves as an interactive gateway to the full AI Finance Hub.
class AiFinanceInsightWidget extends StatelessWidget {
  final FinanceSummaryEntity summary;

  const AiFinanceInsightWidget({
    super.key,
    required this.summary,
  });

  bool get _hasFinanceData {
    return summary.totalIncome > 0 ||
        summary.spentThisMonth > 0 ||
        summary.monthlyBudget > 0 ||
        summary.recentTransactions.isNotEmpty ||
        (summary.activeGoalTitle != null && summary.activeGoalTitle!.isNotEmpty);
  }

  Future<void> _openAiFinanceHub(BuildContext context) async {
    await context.push(RouteNames.aiFinanceHome);
    if (context.mounted) {
      context.read<DashboardBloc>().add(RefreshDashboardEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if the dashboard is actively refreshing
    final isRefreshing = context.watch<DashboardBloc?>()?.state is DashboardRefreshingState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isDark, isRefreshing),
        const SizedBox(height: 12),
        _buildCard(context, isDark, isRefreshing),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isRefreshing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Finance Insight',
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
          key: const Key('ai_finance_gateway_button'),
          onPressed: () => _openAiFinanceHub(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AI Hub',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B5CF6),
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFF8B5CF6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, bool isDark, bool isRefreshing) {
    // 1. Loading State
    if (isRefreshing) {
      return _buildLoadingState(isDark);
    }

    // 2. Empty State (no income, expenses, budget, or goals)
    if (!_hasFinanceData) {
      return _buildEmptyState(context, isDark);
    }

    // 3. Error State (has data, but no tip could be synthesized)
    final tip = summary.aiFinancialTip;
    if (tip == null || tip.trim().isEmpty) {
      return _buildErrorState(context, isDark);
    }

    // 4. Normal Active Insight State
    return _buildInsightContent(context, isDark, tip.trim());
  }

  Widget _buildLoadingState(bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Analyzing your finances...',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 20,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Add some income and expense data to get personalized AI insights.',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    height: 1.4,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('add_finance_data_button'),
                onTap: () async {
                  await context.push(RouteNames.finance);
                  if (context.mounted) {
                    context.read<DashboardBloc>().add(RefreshDashboardEvent());
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 14, color: Color(0xFF6366F1)),
                      SizedBox(width: 4),
                      Text(
                        'Go to Finance',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignColors.errorLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: DesignColors.errorLight,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'AI insight unavailable',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            key: const Key('retry_ai_insight_button'),
            onPressed: () {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B5CF6),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightContent(BuildContext context, bool isDark, String insight) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () => _openAiFinanceHub(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE INSIGHT',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Color(0xFF8B5CF6),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      insight,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Footer action hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tap to view recommendations & forecast',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8B5CF6),
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 13,
                  color: Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
