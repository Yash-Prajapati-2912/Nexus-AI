import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/investment.dart';
import '../bloc/finance_bloc.dart';
import '../bloc/finance_event.dart';
import '../bloc/finance_state.dart';
import '../widgets/finance_skeleton.dart';

class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({super.key});

  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  void _loadInvestments() {
    context.read<FinanceBloc>().add(const LoadFinanceDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.show_chart_rounded, color: DesignColors.secondaryDark, size: 22),
            SizedBox(width: 8),
            Text('Investment Portfolio', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditInvestmentDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Track Asset', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: DesignColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoadingState || state is FinanceInitialState) {
            return const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  FinanceSkeleton(height: 140),
                  SizedBox(height: 16),
                  FinanceSkeleton(height: 72),
                  SizedBox(height: 12),
                  FinanceSkeleton(height: 72),
                ],
              ),
            );
          }

          if (state is FinanceFailureState) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: DesignColors.errorDark),
                    const SizedBox(height: 16),
                    Text(
                      'Unable to load investments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _loadInvestments,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Retry', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          }

          final investments = (state is FinanceLoadedState) ? state.investments : <Investment>[];
          final totalInvested = (state is FinanceLoadedState) ? state.totalInvested : 0.0;
          final totalCurrent = (state is FinanceLoadedState) ? state.totalInvestmentValue : 0.0;
          final netGain = (state is FinanceLoadedState) ? state.investmentGainLoss : 0.0;
          final netGainPct = (state is FinanceLoadedState) ? state.investmentGainLossPct : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disclaimer Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: DesignColors.secondaryDark),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Portfolio Tracking Area • Values are self-reported for planning.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Portfolio Summary Hero Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Portfolio Value',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '₹${totalCurrent.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                                  fontFamily: 'Poppins',
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: (netGain >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  netGain >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  size: 14,
                                  color: netGain >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${netGain >= 0 ? "+" : ""}${netGainPct.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: netGain >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Invested Amount',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${totalInvested.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Returns',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${netGain >= 0 ? "+" : "-"}₹${netGain.abs().toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: netGain >= 0 ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Asset Holdings (${investments.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (investments.isEmpty)
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: DesignColors.secondaryDark.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.show_chart_rounded, color: DesignColors.secondaryDark, size: 32),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No Investments Tracked',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add your mutual funds, stocks, FDs, or gold holdings to monitor portfolio value.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DesignColors.primaryDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _showAddEditInvestmentDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Investment', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: investments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = investments[index];
                      return _buildInvestmentCard(context, item, isDark: isDark);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvestmentCard(BuildContext context, Investment item, {required bool isDark}) {
    final assetIcon = _getAssetIcon(item.assetType);
    final isProfit = item.isProfit;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: DesignColors.secondaryDark.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(assetIcon, color: DesignColors.secondaryDark, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.assetType.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${item.currentValue.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${isProfit ? "+" : ""}${item.gainLossPct.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isProfit ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cost: ₹${item.investedAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  fontFamily: 'Poppins',
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    onPressed: () => _showAddEditInvestmentDialog(context, investment: item),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16, color: DesignColors.errorDark),
                    onPressed: () async {
                      await context.read<FinanceBloc>().repository.deleteInvestment(item.id);
                      if (context.mounted) {
                        context.read<FinanceBloc>().add(const LoadFinanceDashboardEvent());
                      }
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getAssetIcon(String type) {
    switch (type.toUpperCase()) {
      case 'MUTUAL_FUND':
        return Icons.pie_chart_rounded;
      case 'STOCKS':
        return Icons.candlestick_chart_rounded;
      case 'FIXED_DEPOSIT':
        return Icons.lock_clock_rounded;
      case 'GOLD':
        return Icons.workspace_premium_rounded;
      case 'CRYPTO':
        return Icons.currency_bitcoin_rounded;
      default:
        return Icons.account_balance_rounded;
    }
  }

  void _showAddEditInvestmentDialog(BuildContext context, {Investment? investment}) {
    final nameCtrl = TextEditingController(text: investment?.name ?? '');
    final investedCtrl = TextEditingController(text: investment != null ? investment.investedAmount.toString() : '');
    final currentCtrl = TextEditingController(text: investment != null ? investment.currentValue.toString() : '');
    final notesCtrl = TextEditingController(text: investment?.notes ?? '');
    String selectedAsset = investment?.assetType ?? 'MUTUAL_FUND';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(investment != null ? 'Edit Asset' : 'Add Investment Asset', style: const TextStyle(fontFamily: 'Poppins')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Investment Name (e.g. HDFC Index Fund)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedAsset,
                  decoration: const InputDecoration(labelText: 'Asset Category'),
                  items: const [
                    DropdownMenuItem(value: 'MUTUAL_FUND', child: Text('Mutual Fund')),
                    DropdownMenuItem(value: 'STOCKS', child: Text('Stocks')),
                    DropdownMenuItem(value: 'FIXED_DEPOSIT', child: Text('Fixed Deposit')),
                    DropdownMenuItem(value: 'GOLD', child: Text('Gold / Bullion')),
                    DropdownMenuItem(value: 'CRYPTO', child: Text('Cryptocurrency')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Other Asset')),
                  ],
                  onChanged: (val) => selectedAsset = val!,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: investedCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Invested Amount (₹)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: currentCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Current Value (₹)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final invested = double.tryParse(investedCtrl.text.trim()) ?? 0.0;
                final current = double.tryParse(currentCtrl.text.trim()) ?? invested;

                if (name.isEmpty || invested <= 0) return;

                final item = Investment(
                  id: investment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  assetType: selectedAsset,
                  investedAmount: invested,
                  currentValue: current,
                  date: DateTime.now(),
                  notes: notesCtrl.text.trim(),
                );

                if (investment != null) {
                  await context.read<FinanceBloc>().repository.updateInvestment(item);
                } else {
                  await context.read<FinanceBloc>().repository.createInvestment(item);
                }

                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  context.read<FinanceBloc>().add(const LoadFinanceDashboardEvent());
                }
              },
              child: const Text('Save Asset'),
            ),
          ],
        );
      },
    );
  }
}
