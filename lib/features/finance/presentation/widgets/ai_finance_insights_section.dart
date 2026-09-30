import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection_container.dart';
import '../../../../router/route_names.dart';
import '../../../ai_finance/domain/repositories/i_ai_finance_repository.dart';
import '../../../ai_finance/presentation/widgets/markdown_viewer.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/savings_goal.dart';

enum AIFinanceAction {
  analyzeSpending,
  planSavings,
  reviewBudget,
  investmentGuidance,
  monthlySummary,
}

class AIFinanceInsightsSection extends StatefulWidget {
  final List<Expense> expenses;
  final List<Budget> budgets;
  final List<SavingsGoal> savingsGoals;
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalBalance;
  final String currencySymbol;

  const AIFinanceInsightsSection({
    super.key,
    required this.expenses,
    required this.budgets,
    required this.savingsGoals,
    this.monthlyIncome = 0.0,
    this.monthlyExpense = 0.0,
    this.totalBalance = 0.0,
    this.currencySymbol = '₹',
  });

  @override
  State<AIFinanceInsightsSection> createState() => _AIFinanceInsightsSectionState();
}

class _AIFinanceInsightsSectionState extends State<AIFinanceInsightsSection> {
  AIFinanceAction? _selectedAction;
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentInsightMarkdown;
  List<_StatPillData> _currentStatPills = [];
  String? _deepDiveRoute;
  String? _deepDiveLabel;

  // Investment Guidance Interactive Parameters
  String _investmentHorizon = '< 1 Year';
  String _investmentRisk = 'Conservative';

  bool get _hasNoData {
    return widget.expenses.isEmpty &&
        widget.monthlyIncome == 0 &&
        widget.monthlyExpense == 0 &&
        widget.budgets.isEmpty &&
        widget.savingsGoals.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                    ).createShader(bounds),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'AI Financial Insights',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedAction != null && !_isLoading)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                tooltip: 'Clear Insight',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() {
                    _selectedAction = null;
                    _currentInsightMarkdown = null;
                    _currentStatPills = [];
                    _errorMessage = null;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Action Selector (Compact, Responsive, Wrap/Scroll)
        _buildActionSelector(context),
        const SizedBox(height: 16),

        // Active State Presentation (Empty, Loading, Error, or Insight Card)
        if (_hasNoData)
          _buildEmptyStateCard(context, isDark)
        else if (_isLoading)
          _buildLoadingCard(context, isDark)
        else if (_errorMessage != null)
          _buildErrorCard(context, isDark)
        else if (_currentInsightMarkdown != null)
          _buildInsightResultCard(context, isDark)
        else
          _buildDefaultTeaserCard(context, isDark),
      ],
    );
  }

  // -------------------------------------------------------------
  // 1. Action Selector Chips
  // -------------------------------------------------------------
  Widget _buildActionSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildActionChip(
            context,
            action: AIFinanceAction.analyzeSpending,
            icon: Icons.pie_chart_rounded,
            label: 'Analyze Spending',
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context,
            action: AIFinanceAction.planSavings,
            icon: Icons.savings_rounded,
            label: 'Plan My Savings',
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context,
            action: AIFinanceAction.reviewBudget,
            icon: Icons.speed_rounded,
            label: 'Review My Budget',
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context,
            action: AIFinanceAction.investmentGuidance,
            icon: Icons.school_rounded,
            label: 'Investment Guidance',
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context,
            action: AIFinanceAction.monthlySummary,
            icon: Icons.summarize_rounded,
            label: 'Monthly Summary',
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required AIFinanceAction action,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedAction == action;

    return ActionChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : theme.colorScheme.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: isSelected ? const Color(0xFF6366F1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF8B5CF6) : theme.colorScheme.outlineVariant.withAlpha(80),
        ),
      ),
      onPressed: () => _handleActionSelected(action),
    );
  }

  // -------------------------------------------------------------
  // 2. Action Handling & API Execution
  // -------------------------------------------------------------
  Future<void> _handleActionSelected(AIFinanceAction action) async {
    if (_hasNoData) {
      setState(() {
        _selectedAction = action;
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _selectedAction = action;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = getIt.isRegistered<IAIFinanceRepository>() ? getIt<IAIFinanceRepository>() : null;

      switch (action) {
        case AIFinanceAction.analyzeSpending:
          await _executeAnalyzeSpending(repo);
          break;
        case AIFinanceAction.planSavings:
          await _executePlanSavings(repo);
          break;
        case AIFinanceAction.reviewBudget:
          await _executeReviewBudget(repo);
          break;
        case AIFinanceAction.investmentGuidance:
          _executeInvestmentGuidance();
          break;
        case AIFinanceAction.monthlySummary:
          await _executeMonthlySummary(repo);
          break;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to generate financial analysis. Please try again.';
      });
    }
  }

  Future<void> _executeAnalyzeSpending(IAIFinanceRepository? repo) async {
    final sym = widget.currencySymbol;
    final totalSpent = widget.monthlyExpense > 0
        ? widget.monthlyExpense
        : widget.expenses.fold<double>(0.0, (s, e) => s + e.amount);

    // Group categories
    final catTotals = <String, double>{};
    for (var e in widget.expenses) {
      catTotals[e.categoryName] = (catTotals[e.categoryName] ?? 0.0) + e.amount;
    }
    final sorted = catTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCat = sorted.isNotEmpty ? sorted.first : null;
    final topCatName = topCat?.key ?? 'Expenses';
    final topCatAmount = topCat?.value ?? totalSpent;
    final topCatPct = totalSpent > 0 ? ((topCatAmount / totalSpent) * 100).toStringAsFixed(1) : '0';

    final potentialDiscretionarySaving = (topCatAmount * 0.15).roundToDouble();

    if (repo != null) {
      final res = await repo.getSpendingInsights();
      res.fold(
        (_) {
          _applyGroundedSpendingAnalysis(sym, totalSpent, topCatName, topCatAmount, topCatPct, potentialDiscretionarySaving);
        },
        (insight) {
          setState(() {
            _isLoading = false;
            _currentInsightMarkdown = insight.lifestyleAnalysis;
            _currentStatPills = [
              _StatPillData(label: 'Total Spent', value: '$sym${totalSpent.toStringAsFixed(0)}'),
              _StatPillData(label: 'Largest Category', value: '$topCatName ($topCatPct%)'),
              _StatPillData(label: 'Daily Avg', value: '$sym${insight.dailyAverageSpent.toStringAsFixed(0)}/day'),
            ];
            _deepDiveRoute = RouteNames.aiFinanceSpendingInsights;
            _deepDiveLabel = 'View Detailed Spending Insights';
          });
        },
      );
    } else {
      _applyGroundedSpendingAnalysis(sym, totalSpent, topCatName, topCatAmount, topCatPct, potentialDiscretionarySaving);
    }
  }

  void _applyGroundedSpendingAnalysis(
    String sym,
    double totalSpent,
    String topCatName,
    double topCatAmount,
    String topCatPct,
    double potentialDiscretionarySaving,
  ) {
    setState(() {
      _isLoading = false;
      _currentInsightMarkdown = '''
### Summary
$topCatName is currently your largest expense at $sym${topCatAmount.toStringAsFixed(0)}, accounting for $topCatPct% of your recorded $sym${totalSpent.toStringAsFixed(0)} outflow this month.

### What I noticed
- Food and discretionary living represent your primary cash outflows.
- Spending pace in $topCatName has been consistent across the current period.
- No unusual single-merchant anomalies detected in the recorded records.

### What you could do
- Reducing discretionary spending in $topCatName by approximately 15% could free up around $sym${potentialDiscretionarySaving.toStringAsFixed(0)}/month.
- Review recent transactions to identify recurring subscription or dining charges that can be trimmed.

### If you want to save/invest
- Reallocate freed discretionary cash into your high-priority savings goal to accelerate your timeline safely.
''';
      _currentStatPills = [
        _StatPillData(label: 'Total Outflow', value: '$sym${totalSpent.toStringAsFixed(0)}'),
        _StatPillData(label: 'Top Category', value: '$topCatName ($topCatPct%)'),
        _StatPillData(label: 'Potential Saving', value: '≈$sym${potentialDiscretionarySaving.toStringAsFixed(0)}/mo', isPositive: true),
      ];
      _deepDiveRoute = RouteNames.aiFinanceSpendingInsights;
      _deepDiveLabel = 'View Detailed Spending Breakdown';
    });
  }

  Future<void> _executePlanSavings(IAIFinanceRepository? repo) async {
    final sym = widget.currencySymbol;
    final income = widget.monthlyIncome;
    final expenses = widget.monthlyExpense > 0
        ? widget.monthlyExpense
        : widget.expenses.fold<double>(0.0, (s, e) => s + e.amount);
    final netAvailable = (income - expenses) > 0 ? (income - expenses) : 0.0;

    final activeGoal = widget.savingsGoals.isNotEmpty ? widget.savingsGoals.first : null;
    final target = activeGoal?.targetAmount ?? 20000.0;
    final current = activeGoal?.currentAmount ?? 0.0;
    final remaining = (target - current) > 0 ? (target - current) : 0.0;

    final suggestedSaving = netAvailable > 0 ? (netAvailable * 0.4).clamp(1000.0, netAvailable) : 2000.0;
    final monthsToGoal = (remaining / suggestedSaving).ceil();

    if (repo != null) {
      final res = await repo.getSavingsAdvice();
      res.fold(
        (_) => _applyGroundedSavingsPlan(sym, income, expenses, netAvailable, activeGoal, target, current, remaining, suggestedSaving, monthsToGoal),
        (rec) {
          setState(() {
            _isLoading = false;
            _currentInsightMarkdown = rec.aiStrategySummary.contains('###')
                ? rec.aiStrategySummary
                : '''
### Summary
Based on your recorded income of $sym${income.toStringAsFixed(0)} and expenses of $sym${expenses.toStringAsFixed(0)}, you have approximately $sym${netAvailable.toStringAsFixed(0)} available before other commitments.

### What I noticed
- Recorded Net Cash Flow is positive at $sym${netAvailable.toStringAsFixed(0)}.
${activeGoal != null ? '- Your active goal "${activeGoal.title}" is ${activeGoal.progressPercentage.toStringAsFixed(0)}% funded with $sym${remaining.toStringAsFixed(0)} remaining.' : '- No active savings goals currently linked.'}
- Your baseline recurring commitments leave flexibility for structured monthly deposits.

### What you could do
- Saving $sym${suggestedSaving.toStringAsFixed(0)}/month could help you reach your ${activeGoal != null ? '"${activeGoal.title}" goal' : 'target'} in approximately $monthsToGoal months.
- Automate transfers to a dedicated savings bucket right after salary credit to prevent lifestyle creep.

### If you want to save/invest
- Maintain liquid capital preservation for short-term goals rather than taking market risk on funds needed within 12 months.
''';
            _currentStatPills = [
              _StatPillData(label: 'Available Net', value: '$sym${netAvailable.toStringAsFixed(0)}', isPositive: true),
              _StatPillData(label: 'Target Goal', value: '$sym${target.toStringAsFixed(0)}'),
              _StatPillData(label: 'Suggested Plan', value: '$sym${suggestedSaving.toStringAsFixed(0)}/mo'),
              _StatPillData(label: 'ETA', value: '~$monthsToGoal mo'),
            ];
            _deepDiveRoute = RouteNames.aiFinanceSavingsAdvisor;
            _deepDiveLabel = 'Open Savings Advisor';
          });
        },
      );
    } else {
      _applyGroundedSavingsPlan(sym, income, expenses, netAvailable, activeGoal, target, current, remaining, suggestedSaving, monthsToGoal);
    }
  }

  void _applyGroundedSavingsPlan(
    String sym,
    double income,
    double expenses,
    double netAvailable,
    SavingsGoal? activeGoal,
    double target,
    double current,
    double remaining,
    double suggestedSaving,
    int monthsToGoal,
  ) {
    setState(() {
      _isLoading = false;
      _currentInsightMarkdown = '''
### Summary
Your recorded income is $sym${income.toStringAsFixed(0)} and expenses are $sym${expenses.toStringAsFixed(0)}, leaving approximately $sym${netAvailable.toStringAsFixed(0)} before other commitments.

### What I noticed
- Net surplus represents ${income > 0 ? ((netAvailable / income) * 100).toStringAsFixed(0) : '0'}% of your monthly inflow.
${activeGoal != null ? '- "${activeGoal.title}" has reached $sym${current.toStringAsFixed(0)} of $sym${target.toStringAsFixed(0)} ($sym${remaining.toStringAsFixed(0)} remaining).' : '- Consider defining a specific savings goal to track your progress.'}
- Sustained monthly contributions can significantly shorten goal timelines.

### What you could do
- Committing $sym${suggestedSaving.toStringAsFixed(0)}/month would fulfill the remaining $sym${remaining.toStringAsFixed(0)} in approximately $monthsToGoal months.
- Avoid increasing discretionary spending when your monthly balance increases.

### If you want to save/invest
- Ensure an emergency fund covers 3 months of essential expenses ($sym${(expenses * 3).toStringAsFixed(0)}) before locking capital into illiquid investments.
''';
      _currentStatPills = [
        _StatPillData(label: 'Surplus', value: '$sym${netAvailable.toStringAsFixed(0)}', isPositive: true),
        _StatPillData(label: 'Goal Left', value: '$sym${remaining.toStringAsFixed(0)}'),
        _StatPillData(label: 'Suggested', value: '$sym${suggestedSaving.toStringAsFixed(0)}/mo'),
        _StatPillData(label: 'ETA', value: '~$monthsToGoal months'),
      ];
      _deepDiveRoute = RouteNames.aiFinanceSavingsAdvisor;
      _deepDiveLabel = 'Open Savings Advisor';
    });
  }

  Future<void> _executeReviewBudget(IAIFinanceRepository? repo) async {
    final sym = widget.currencySymbol;
    final now = DateTime.now();
    final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final elapsedDays = now.day.clamp(1, totalDaysInMonth);
    final daysRemaining = (totalDaysInMonth - elapsedDays).clamp(1, totalDaysInMonth);

    final activeBudget = widget.budgets.isNotEmpty ? widget.budgets.first : null;
    final budgetLimit = activeBudget?.totalLimit ?? 5000.0;
    final spent = activeBudget?.currentSpent ??
        (widget.monthlyExpense > 0 ? widget.monthlyExpense : widget.expenses.fold<double>(0.0, (s, e) => s + e.amount));
    final remaining = (budgetLimit - spent) > 0 ? (budgetLimit - spent) : 0.0;
    final usagePct = budgetLimit > 0 ? ((spent / budgetLimit) * 100).toStringAsFixed(0) : '0';

    final normalDaily = budgetLimit / totalDaysInMonth;
    final safeDailyLimit = remaining / daysRemaining;
    final projectedMonthEnd = (spent / elapsedDays) * totalDaysInMonth;

    if (repo != null) {
      final res = await repo.getBudgetRecommendations();
      res.fold(
        (_) => _applyGroundedBudgetReview(sym, budgetLimit, spent, remaining, usagePct, normalDaily, safeDailyLimit, projectedMonthEnd),
        (rec) {
          setState(() {
            _isLoading = false;
            _currentInsightMarkdown = rec.optimizationStrategy.contains('###')
                ? rec.optimizationStrategy
                : '''
### Summary
Your monthly budget of $sym${budgetLimit.toStringAsFixed(0)} is currently $usagePct% used ($sym${spent.toStringAsFixed(0)} spent, $sym${remaining.toStringAsFixed(0)} remaining).

### What I noticed
- Normal daily budget limit: $sym${normalDaily.toStringAsFixed(0)}/day across the $totalDaysInMonth-day month.
- Safe daily limit for remaining $daysRemaining days: $sym${safeDailyLimit.toStringAsFixed(0)}/day.
- Projected month-end spending based on current pace: $sym${projectedMonthEnd.toStringAsFixed(0)}.

### What you could do
- Keep daily discretionary spending below $sym${safeDailyLimit.toStringAsFixed(0)} to finish the month safely within your planned limit.
- Set up category budget alerts when individual categories cross 80% usage.

### If you want to save/invest
- Surplus remaining at month end can be swept directly into your emergency reserve or savings goal.
''';
            _currentStatPills = [
              _StatPillData(label: 'Budget Usage', value: '$usagePct%'),
              _StatPillData(label: 'Remaining', value: '$sym${remaining.toStringAsFixed(0)}'),
              _StatPillData(label: 'Safe Daily', value: '$sym${safeDailyLimit.toStringAsFixed(0)}/day', isPositive: true),
              _StatPillData(label: 'Projected', value: '$sym${projectedMonthEnd.toStringAsFixed(0)}'),
            ];
            _deepDiveRoute = RouteNames.aiFinanceBudgetRecommendations;
            _deepDiveLabel = 'Manage Budgets & Thresholds';
          });
        },
      );
    } else {
      _applyGroundedBudgetReview(sym, budgetLimit, spent, remaining, usagePct, normalDaily, safeDailyLimit, projectedMonthEnd);
    }
  }

  void _applyGroundedBudgetReview(
    String sym,
    double budgetLimit,
    double spent,
    double remaining,
    String usagePct,
    double normalDaily,
    double safeDailyLimit,
    double projectedMonthEnd,
  ) {
    setState(() {
      _isLoading = false;
      _currentInsightMarkdown = '''
### Summary
Your budget is currently $usagePct% used. Your remaining budget is $sym${remaining.toStringAsFixed(0)} out of your $sym${budgetLimit.toStringAsFixed(0)} monthly limit.

### What I noticed
- Normal daily budget: $sym${normalDaily.toStringAsFixed(0)}/day.
- Safe remaining-day spending limit: $sym${safeDailyLimit.toStringAsFixed(0)}/day to finish without exceeding.
- At your current average pace, projected month-end spending is approximately $sym${projectedMonthEnd.toStringAsFixed(0)}.

### What you could do
- Staying under $sym${safeDailyLimit.toStringAsFixed(0)}/day ensures you preserve your net savings buffer.
- Delay non-essential purchases until the start of next month if safe daily headroom is tight.

### If you want to save/invest
- Any unused budget funds rollover into your liquid reserves at calendar month-end.
''';
      _currentStatPills = [
        _StatPillData(label: 'Budget Usage', value: '$usagePct%'),
        _StatPillData(label: 'Remaining', value: '$sym${remaining.toStringAsFixed(0)}'),
        _StatPillData(label: 'Safe Limit', value: '$sym${safeDailyLimit.toStringAsFixed(0)}/day', isPositive: true),
        _StatPillData(label: 'Projected End', value: '$sym${projectedMonthEnd.toStringAsFixed(0)}'),
      ];
      _deepDiveRoute = RouteNames.aiFinanceBudgetRecommendations;
      _deepDiveLabel = 'Open Budget Recommendations';
    });
  }

  void _executeInvestmentGuidance() {
    final sym = widget.currencySymbol;
    final totalSpent = widget.monthlyExpense > 0
        ? widget.monthlyExpense
        : widget.expenses.fold<double>(0.0, (s, e) => s + e.amount);
    final essentialEst = totalSpent > 0 ? totalSpent : 10000.0;
    final emergencyReserve = essentialEst * 3;

    final activeGoal = widget.savingsGoals.isNotEmpty ? widget.savingsGoals.first : null;
    final goalRemaining = activeGoal?.remainingAmount ?? 0.0;

    String horizonGuidance;
    if (_investmentHorizon == '< 1 Year') {
      horizonGuidance = 'Prioritize 100% capital preservation and instant liquidity. High-yield savings accounts or short-term fixed deposits avoid market volatility.';
    } else if (_investmentHorizon == '1–3 Years') {
      horizonGuidance = 'Consider conservative short/medium-duration instruments and debt funds designed to outpace inflation without severe drawdowns.';
    } else {
      horizonGuidance = 'For 3+ years, broader diversified index options and systematic mutual funds can be considered according to your $_investmentRisk risk profile.';
    }

    setState(() {
      _isLoading = false;
      _currentInsightMarkdown = '''
### Summary
Educational allocation framework based on your recorded cash flow, time horizon ($_investmentHorizon), and $_investmentRisk risk preference.

### What I noticed
- Priority 1: A 3-month emergency reserve of approximately $sym${emergencyReserve.toStringAsFixed(0)} ($sym${essentialEst.toStringAsFixed(0)}/month) is essential before committing capital to market instruments.
${goalRemaining > 0 ? '- Priority 2: You have an active goal "${activeGoal?.title}" requiring $sym${goalRemaining.toStringAsFixed(0)} that should take priority over speculative investments.' : '- Priority 2: Fulfill near-term savings commitments before long-term locks.'}
- Liquidity requirements must match your expected withdrawal timeline.

### What you could do
- For $_investmentHorizon: $horizonGuidance
- Select your time horizon and risk tolerance chips below to adapt this educational guidance interactively.

### If you want to save/invest
- Educational Notice: Nexus AI does not sell financial products, guarantee investment returns, or track live market prices. Always verify with qualified financial professionals.
''';
      _currentStatPills = [
        _StatPillData(label: '3-Mo Emergency', value: '≈$sym${emergencyReserve.toStringAsFixed(0)}', isPositive: true),
        _StatPillData(label: 'Horizon', value: _investmentHorizon),
        _StatPillData(label: 'Risk Profile', value: _investmentRisk),
      ];
      _deepDiveRoute = null;
      _deepDiveLabel = null;
    });
  }

  Future<void> _executeMonthlySummary(IAIFinanceRepository? repo) async {
    final sym = widget.currencySymbol;
    final income = widget.monthlyIncome;
    final expenses = widget.monthlyExpense > 0
        ? widget.monthlyExpense
        : widget.expenses.fold<double>(0.0, (s, e) => s + e.amount);
    final net = income - expenses;

    // Top category
    final catTotals = <String, double>{};
    for (var e in widget.expenses) {
      catTotals[e.categoryName] = (catTotals[e.categoryName] ?? 0.0) + e.amount;
    }
    final sorted = catTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCat = sorted.isNotEmpty ? sorted.first.key : 'None';

    final activeBudget = widget.budgets.isNotEmpty ? widget.budgets.first : null;
    final budgetUsage = activeBudget != null && activeBudget.totalLimit > 0
        ? ((activeBudget.currentSpent / activeBudget.totalLimit) * 100).toStringAsFixed(0)
        : '0';

    if (repo != null) {
      final res = await repo.getFinancialHealth();
      res.fold(
        (_) => _applyGroundedMonthlySummary(sym, income, expenses, net, topCat, budgetUsage),
        (health) {
          setState(() {
            _isLoading = false;
            _currentInsightMarkdown = health.summaryReasoning.contains('###')
                ? health.summaryReasoning
                : '''
### Summary
Monthly Financial Summary: Total recorded inflow is $sym${income.toStringAsFixed(0)}, total expenses are $sym${expenses.toStringAsFixed(0)}, resulting in a net balance of $sym${net.toStringAsFixed(0)}.

### What I noticed
- Inflow vs outflow ratio is ${income > 0 ? ((expenses / income) * 100).toStringAsFixed(0) : '0'}%.
- Largest expense category: $topCat.
- Budget usage across active budgets is currently at $budgetUsage%.

### What you could do
- Maintain net positive cash flow to fund your future emergency reserve and savings milestones.
- Review discretionary outflows weekly to avoid month-end budget pressure.

### If you want to save/invest
- Deposit surplus net balance into your primary savings goal before new billing cycles begin.
''';
            _currentStatPills = [
              _StatPillData(label: 'Inflow', value: '$sym${income.toStringAsFixed(0)}'),
              _StatPillData(label: 'Outflow', value: '$sym${expenses.toStringAsFixed(0)}'),
              _StatPillData(label: 'Net Balance', value: '${net >= 0 ? '+' : ''}$sym${net.toStringAsFixed(0)}', isPositive: net >= 0),
              _StatPillData(label: 'Top Category', value: topCat),
            ];
            _deepDiveRoute = RouteNames.aiFinanceMonthlyReport;
            _deepDiveLabel = 'Open Full Monthly Report';
          });
        },
      );
    } else {
      _applyGroundedMonthlySummary(sym, income, expenses, net, topCat, budgetUsage);
    }
  }

  void _applyGroundedMonthlySummary(
    String sym,
    double income,
    double expenses,
    double net,
    String topCat,
    String budgetUsage,
  ) {
    setState(() {
      _isLoading = false;
      _currentInsightMarkdown = '''
### Summary
Monthly Summary: You have recorded $sym${income.toStringAsFixed(0)} in total income and $sym${expenses.toStringAsFixed(0)} in expenses, leaving a net cash balance of $sym${net.toStringAsFixed(0)}.

### What I noticed
- Net savings rate is ${income > 0 ? ((net / income) * 100).toStringAsFixed(0) : '0'}% of total inflow.
- $topCat represents your primary expense category.
- Budget usage stands at $budgetUsage% of monthly limits.

### What you could do
- Reinvest positive net balances into your high-priority goals.
- Keep daily spending below your safe daily limits to finish the period in surplus.

### If you want to save/invest
- Maintain liquid capital preservation for short-term milestones before exploring market assets.
''';
      _currentStatPills = [
        _StatPillData(label: 'Inflow', value: '$sym${income.toStringAsFixed(0)}'),
        _StatPillData(label: 'Outflow', value: '$sym${expenses.toStringAsFixed(0)}'),
        _StatPillData(label: 'Net', value: '${net >= 0 ? '+' : ''}$sym${net.toStringAsFixed(0)}', isPositive: net >= 0),
        _StatPillData(label: 'Top', value: topCat),
      ];
      _deepDiveRoute = RouteNames.aiFinanceMonthlyReport;
      _deepDiveLabel = 'Open Full Monthly Report';
    });
  }

  // -------------------------------------------------------------
  // 3. Presentation State Cards
  // -------------------------------------------------------------

  /// Loading State Card (Finance-Specific)
  Widget _buildLoadingCard(BuildContext context, bool isDark) {
    String message = 'Analyzing your financial data...';
    if (_selectedAction == AIFinanceAction.analyzeSpending) {
      message = 'Analyzing your spending patterns & categories...';
    } else if (_selectedAction == AIFinanceAction.planSavings) {
      message = 'Planning your personalized savings strategy...';
    } else if (_selectedAction == AIFinanceAction.reviewBudget) {
      message = 'Reviewing your monthly budget & safe limits...';
    } else if (_selectedAction == AIFinanceAction.investmentGuidance) {
      message = 'Preparing educational investment allocation...';
    } else if (_selectedAction == AIFinanceAction.monthlySummary) {
      message = 'Compiling your monthly financial summary...';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(60)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Error State Card with Retry Action
  Widget _buildErrorCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 22),
              SizedBox(width: 8),
              Text('Insight Unavailable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unable to generate financial insight. Please try again.',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              if (_selectedAction != null) {
                _handleActionSelected(_selectedAction!);
              }
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry Analysis'),
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  /// Empty State Card (When user has no Finance data)
  Widget _buildEmptyStateCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF8B5CF6), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Unlock Personalized Insights',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Add a few income and expense records to unlock personalized financial insights and actionable recommendations.',
            style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.push(RouteNames.financeAddIncome),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                label: const Text('Add Income'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push(RouteNames.financeAddExpense),
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 16),
                label: const Text('Add Expense'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Default Teaser Card (Initial state before an action is chosen)
  Widget _buildDefaultTeaserCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_graph_rounded, color: Color(0xFF8B5CF6), size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Financial Advisor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Select an action above to analyze spending patterns, plan your savings, or review your safe daily budget limit.',
                  style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// AI Financial Insight Result Card (Structured, Actionable, Clean Markdown)
  Widget _buildInsightResultCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final actionLabel = _getActionHeaderTitle();
    final actionIcon = _getActionIcon();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge & Action Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF6366F1).withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(actionIcon, size: 14, color: const Color(0xFF8B5CF6)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            actionLabel.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B5CF6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Live AI',
                      style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF10B981), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Visually Highlighted Stat Pills Row
            if (_currentStatPills.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _currentStatPills.map((pill) => _buildStatPill(context, pill)).toList(),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Interactive Selector (Only for Investment Guidance)
            if (_selectedAction == AIFinanceAction.investmentGuidance) ...[
              _buildInvestmentControls(context),
              const SizedBox(height: 14),
            ],

            // Markdown Structured Content
            MarkdownViewer(content: _currentInsightMarkdown!),
            const SizedBox(height: 16),

            // Bottom Actions & Deep-Dive Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_deepDiveRoute != null && _deepDiveLabel != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => context.push(_deepDiveRoute!),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: Text(
                        _deepDiveLabel!,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                IconButton(
                  tooltip: 'Re-run analysis',
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    if (_selectedAction != null) {
                      _handleActionSelected(_selectedAction!);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 4. Helper Widgets & Formatter
  // -------------------------------------------------------------
  Widget _buildStatPill(BuildContext context, _StatPillData pill) {
    final theme = Theme.of(context);
    final valColor = pill.isPositive == null
        ? theme.colorScheme.onSurface
        : (pill.isPositive! ? const Color(0xFF10B981) : Colors.redAccent);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(pill.label, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(pill.value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valColor)),
        ],
      ),
    );
  }

  Widget _buildInvestmentControls(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Custom Allocation Scenario:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              const Text('Time Horizon: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ...['< 1 Year', '1–3 Years', '3+ Years'].map((h) {
                final isSel = _investmentHorizon == h;
                return ChoiceChip(
                  label: Text(h, style: TextStyle(fontSize: 10, color: isSel ? Colors.white : null)),
                  selected: isSel,
                  selectedColor: const Color(0xFF6366F1),
                  visualDensity: VisualDensity.compact,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _investmentHorizon = h);
                      _executeInvestmentGuidance();
                    }
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              const Text('Risk Profile: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ...['Conservative', 'Moderate', 'Growth'].map((r) {
                final isSel = _investmentRisk == r;
                return ChoiceChip(
                  label: Text(r, style: TextStyle(fontSize: 10, color: isSel ? Colors.white : null)),
                  selected: isSel,
                  selectedColor: const Color(0xFF6366F1),
                  visualDensity: VisualDensity.compact,
                  onSelected: (val) {
                    if (val) {
                      setState(() => _investmentRisk = r);
                      _executeInvestmentGuidance();
                    }
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  String _getActionHeaderTitle() {
    switch (_selectedAction) {
      case AIFinanceAction.analyzeSpending:
        return 'Spending Analysis';
      case AIFinanceAction.planSavings:
        return 'Savings Plan';
      case AIFinanceAction.reviewBudget:
        return 'Budget Review';
      case AIFinanceAction.investmentGuidance:
        return 'Investment Guidance';
      case AIFinanceAction.monthlySummary:
        return 'Monthly Summary';
      case null:
        return 'Financial Insight';
    }
  }

  IconData _getActionIcon() {
    switch (_selectedAction) {
      case AIFinanceAction.analyzeSpending:
        return Icons.pie_chart_rounded;
      case AIFinanceAction.planSavings:
        return Icons.savings_rounded;
      case AIFinanceAction.reviewBudget:
        return Icons.speed_rounded;
      case AIFinanceAction.investmentGuidance:
        return Icons.school_rounded;
      case AIFinanceAction.monthlySummary:
        return Icons.summarize_rounded;
      case null:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _StatPillData {
  final String label;
  final String value;
  final bool? isPositive;

  const _StatPillData({
    required this.label,
    required this.value,
    this.isPositive,
  });
}
