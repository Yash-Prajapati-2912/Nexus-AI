import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/savings_goal.dart';
import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';
import '../bloc/finance_state.dart';
import '../widgets/ai_finance_insights_section.dart';
import '../widgets/budget_health_card.dart';
import '../widgets/cash_flow_chart_widget.dart';
import '../widgets/expense_card.dart';
import '../widgets/financial_hero_card.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/floating_quick_actions_bar.dart';
import '../widgets/savings_goal_card.dart';
import '../widgets/spending_donut_chart_widget.dart';
import '../widgets/transparent_financial_health_card.dart';

class FinanceDashboardPage extends StatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  State<FinanceDashboardPage> createState() => _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends State<FinanceDashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<FinanceBloc>().add(const LoadFinanceDashboardEvent());
  }

  Future<void> _navigateTo(String routeName) async {
    await context.push(routeName);
    if (mounted) {
      _loadDashboard();
    }
  }

  String _selectedCashFlowTimeframe = '1M';

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Map<String, dynamic> _buildCashFlowData(
    String timeframe,
    List<Expense> expenses,
    double monthlyIncome,
    double monthlyExpense,
  ) {
    final now = DateTime.now();

    if (timeframe == '7D') {
      final List<String> labels = [];
      final List<double> incomeSeries = [];
      final List<double> expenseSeries = [];

      for (int i = 6; i >= 0; i--) {
        final d = now.subtract(Duration(days: i));
        final dayLabel = '${d.day} ${_months[d.month - 1].substring(0, 3)}';
        labels.add(dayLabel);

        final dayExpenses = expenses.where(
          (e) => e.date.year == d.year && e.date.month == d.month && e.date.day == d.day,
        );
        final sumExp = dayExpenses.fold(0.0, (s, e) => s + e.amount);
        expenseSeries.add(sumExp);
        incomeSeries.add(0.0);
      }

      return {'labels': labels, 'income': incomeSeries, 'expense': expenseSeries};
    } else if (timeframe == '1M') {
      final labels = ['W1 (1-7)', 'W2 (8-14)', 'W3 (15-21)', 'W4 (22-30)'];
      final List<double> expenseSeries = [0.0, 0.0, 0.0, 0.0];
      final List<double> incomeSeries = [0.0, 0.0, 0.0, monthlyIncome];

      for (var e in expenses) {
        if (e.date.year == now.year && e.date.month == now.month) {
          final day = e.date.day;
          if (day <= 7) {
            expenseSeries[0] += e.amount;
          } else if (day <= 14) {
            expenseSeries[1] += e.amount;
          } else if (day <= 21) {
            expenseSeries[2] += e.amount;
          } else {
            expenseSeries[3] += e.amount;
          }
        }
      }

      return {'labels': labels, 'income': incomeSeries, 'expense': expenseSeries};
    } else if (timeframe == '3M') {
      final List<String> labels = [];
      final List<double> expenseSeries = [];
      final List<double> incomeSeries = [];

      for (int i = 2; i >= 0; i--) {
        final mDate = DateTime(now.year, now.month - i, 1);
        labels.add(_months[mDate.month - 1].substring(0, 3));

        final mExpenses = expenses.where(
          (e) => e.date.year == mDate.year && e.date.month == mDate.month,
        );
        final sumExp = mExpenses.fold(0.0, (s, e) => s + e.amount);
        expenseSeries.add(sumExp > 0 ? sumExp : (i == 0 ? monthlyExpense : 0.0));
        incomeSeries.add(i == 0 ? monthlyIncome : 0.0);
      }

      return {'labels': labels, 'income': incomeSeries, 'expense': expenseSeries};
    } else {
      final List<String> labels = [];
      final List<double> expenseSeries = [];
      final List<double> incomeSeries = [];

      for (int i = 5; i >= 0; i--) {
        final mDate = DateTime(now.year, now.month - i, 1);
        labels.add(_months[mDate.month - 1].substring(0, 3));

        final mExpenses = expenses.where(
          (e) => e.date.year == mDate.year && e.date.month == mDate.month,
        );
        final sumExp = mExpenses.fold(0.0, (s, e) => s + e.amount);
        expenseSeries.add(sumExp > 0 ? sumExp : (i == 0 ? monthlyExpense : 0.0));
        incomeSeries.add(i == 0 ? monthlyIncome : 0.0);
      }

      return {'labels': labels, 'income': incomeSeries, 'expense': expenseSeries};
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthString = '${_months[now.month - 1]} ${now.year}';

    return BaseScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Smart Finance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 6),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                  ).createShader(bounds),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
            Text(monthString, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _navigateTo(RouteNames.financeSearch),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _navigateTo(RouteNames.financeFilter),
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => _navigateTo(RouteNames.financeReports),
            tooltip: 'Reports',
          ),
        ],
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  FinanceSkeleton(height: 180),
                  SizedBox(height: 16),
                  FinanceSkeleton(height: 120),
                  SizedBox(height: 16),
                  FinanceSkeleton(height: 140),
                ],
              ),
            );
          }

          final totalBalance = (state is FinanceLoadedState) ? state.totalBalance : 0.0;
          final monthlyExpense = (state is FinanceLoadedState) ? state.monthlyExpenseTotal : 0.0;
          final monthlyIncome = (state is FinanceLoadedState) ? state.monthlyIncomeTotal : 0.0;
          final List<Expense> recentExpenses = (state is FinanceLoadedState) ? state.recentExpenses : const [];
          final List<Budget> activeBudgets = (state is FinanceLoadedState) ? state.activeBudgets : const [];
          final List<SavingsGoal> activeGoals = (state is FinanceLoadedState) ? state.activeGoals : const [];

          final activeBudget = activeBudgets.isNotEmpty ? activeBudgets.first : null;
          final plannedAmount = activeBudget?.totalLimit ?? 0.0;
          final currentSpent = activeBudget?.currentSpent ?? monthlyExpense;

          final hasTransactions = recentExpenses.isNotEmpty || monthlyIncome > 0 || monthlyExpense > 0;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FinanceBloc>().add(const RefreshFinanceDashboardEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 8 — Floating Quick Actions
                  FloatingQuickActionsBar(
                    onAddExpense: () => _navigateTo(RouteNames.financeAddExpense),
                    onAddIncome: () => _navigateTo(RouteNames.financeAddIncome),
                    onBudgets: () => _navigateTo(RouteNames.financeBudgets),
                    onSavings: () => _navigateTo(RouteNames.financeSavings),
                    onAnalytics: () => _navigateTo(RouteNames.financeReports),
                  ),

                  const SizedBox(height: 20),

                  // Section 2 — Financial Hero Card
                  FinancialHeroCard(
                    availableBalance: totalBalance,
                    monthlyIncome: monthlyIncome,
                    monthlyExpense: monthlyExpense,
                  ),

                  const SizedBox(height: 20),

                  // Onboarding state if zero transactions exist
                  if (!hasTransactions)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.indigoAccent),
                            const SizedBox(height: 12),
                            const Text('Your Smart Finance Command Center is Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            const Text(
                              'Track your daily expenses, set your first monthly budget, or create a savings goal to unlock AI cash-flow insights.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _navigateTo(RouteNames.financeAddExpense),
                                  icon: const Icon(Icons.add_rounded, size: 18),
                                  label: const Text('Add Expense'),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () => _navigateTo(RouteNames.financeCreateBudget),
                                  icon: const Icon(Icons.pie_chart_rounded, size: 18),
                                  label: const Text('Set Budget'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Section 3 — Cash Flow Trend Graph
                  Builder(
                    builder: (context) {
                      final cfData = _buildCashFlowData(
                        _selectedCashFlowTimeframe,
                        recentExpenses,
                        monthlyIncome,
                        monthlyExpense,
                      );
                      return CashFlowChartWidget(
                        incomeSeries: List<double>.from(cfData['income'] as List),
                        expenseSeries: List<double>.from(cfData['expense'] as List),
                        labels: List<String>.from(cfData['labels'] as List),
                        onTimeframeChanged: (tf) {
                          setState(() => _selectedCashFlowTimeframe = tf);
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Section 4 & 5 — Spending Breakdown & Budget Health
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: SpendingDonutChartWidget(expenses: recentExpenses)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: BudgetHealthCard(
                                plannedAmount: plannedAmount,
                                currentSpent: currentSpent,
                                onSetBudgetTap: () => _navigateTo(RouteNames.financeCreateBudget),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          SpendingDonutChartWidget(expenses: recentExpenses),
                          const SizedBox(height: 20),
                          BudgetHealthCard(
                            plannedAmount: plannedAmount,
                            currentSpent: currentSpent,
                            onSetBudgetTap: () => _navigateTo(RouteNames.financeCreateBudget),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Section 6 — Savings Goals Carousel
                  if (activeGoals.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Active Savings Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => _navigateTo(RouteNames.financeSavings),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: activeGoals.length,
                        itemBuilder: (context, index) {
                          final goal = activeGoals[index];
                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            child: SavingsGoalCard(
                              goal: goal,
                              onTap: () => _navigateTo(RouteNames.financeSavings),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Section 7 — AI Financial Insights
                  AIFinanceInsightsSection(
                    expenses: recentExpenses,
                    budgets: activeBudgets,
                    savingsGoals: activeGoals,
                  ),

                  const SizedBox(height: 20),

                  // Section 10 — Transparent Financial Health Score
                  TransparentFinancialHealthCard(
                    monthlyIncome: monthlyIncome,
                    monthlyExpense: monthlyExpense,
                    totalBudget: plannedAmount,
                    currentSpent: currentSpent,
                    savingsProgressPct: activeGoals.isNotEmpty ? activeGoals.first.progressPercentage : 0.0,
                  ),

                  const SizedBox(height: 24),

                  // Section 9 — Recent Activity / Transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => _navigateTo(RouteNames.financeExpenses),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recentExpenses.isEmpty)
                    const Center(child: Text('No expense records found.'))
                  else
                    ...recentExpenses.map((exp) => ExpenseCard(
                          expense: exp,
                          onTap: () => context.push(RouteNames.financeExpenseDetails, extra: exp),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
