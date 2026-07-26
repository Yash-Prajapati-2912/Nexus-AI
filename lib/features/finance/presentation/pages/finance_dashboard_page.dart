import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/expense.dart';
import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';
import '../bloc/finance_state.dart';
import '../widgets/budget_card.dart';
import '../widgets/expense_card.dart';
import '../widgets/finance_header.dart';
import '../widgets/finance_skeleton.dart';
import '../widgets/finance_summary_card.dart';

class FinanceDashboardPage extends StatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  State<FinanceDashboardPage> createState() => _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends State<FinanceDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<FinanceBloc>().add(const LoadFinanceDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Finance', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RouteNames.financeSearch),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => context.push(RouteNames.financeFilter),
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => context.push(RouteNames.financeReports),
            tooltip: 'Reports',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.financeAddExpense),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Expense'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FinanceBloc>().add(const RefreshFinanceDashboardEvent());
        },
        child: BlocBuilder<FinanceBloc, FinanceState>(
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
                    FinanceSkeleton(height: 120),
                  ],
                ),
              );
            }

            final totalBalance = (state is FinanceLoadedState) ? state.totalBalance : 2450.75;
            final monthlyExpense = (state is FinanceLoadedState) ? state.monthlyExpenseTotal : 840.50;
            final monthlyIncome = (state is FinanceLoadedState) ? state.monthlyIncomeTotal : 3291.25;
            final List<Expense> recentExpenses = (state is FinanceLoadedState) ? state.recentExpenses : const [];
            final List<Budget> activeBudgets = (state is FinanceLoadedState) ? state.activeBudgets : const [];


            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinanceSummaryCard(
                    totalBalance: totalBalance,
                    incomeTotal: monthlyIncome,
                    expenseTotal: monthlyExpense,
                  ),

                  const SizedBox(height: 24),
                  // Quick Actions grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _QuickActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: 'Expenses',
                        color: Colors.redAccent,
                        onTap: () => context.push(RouteNames.financeExpenses),
                      ),
                      _QuickActionButton(
                        icon: Icons.account_balance_wallet_rounded,
                        label: 'Income',
                        color: const Color(0xFF10B981),
                        onTap: () => context.push(RouteNames.financeIncome),
                      ),
                      _QuickActionButton(
                        icon: Icons.pie_chart_rounded,
                        label: 'Budgets',
                        color: Colors.purpleAccent,
                        onTap: () => context.push(RouteNames.financeBudgets),
                      ),
                      _QuickActionButton(
                        icon: Icons.savings_rounded,
                        label: 'Savings',
                        color: Colors.amber,
                        onTap: () => context.push(RouteNames.financeSavings),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  FinanceHeader(
                    title: 'Active Budgets',
                    trailing: TextButton(
                      onPressed: () => context.push(RouteNames.financeBudgets),
                      child: const Text('View All'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (activeBudgets.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded),
                            const SizedBox(width: 12),
                            const Expanded(child: Text('No active budgets set for this month.')),
                            TextButton(
                              onPressed: () => context.push(RouteNames.financeBudgets),
                              child: const Text('Set Budget'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...activeBudgets.take(2).map((b) => BudgetCard(budget: b)),

                  const SizedBox(height: 24),
                  FinanceHeader(
                    title: 'Recent Expenses',
                    trailing: TextButton(
                      onPressed: () => context.push(RouteNames.financeExpenses),
                      child: const Text('View All'),
                    ),
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
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withAlpha(35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
