import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/chart_data_entity.dart';

class ExpenseChartWidget extends StatefulWidget {
  final List<ChartDataPoint> data;
  final double totalIncome;
  final double totalExpenses;

  const ExpenseChartWidget({
    super.key,
    required this.data,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
  });

  @override
  State<ExpenseChartWidget> createState() => _ExpenseChartWidgetState();
}

class _ExpenseChartWidgetState extends State<ExpenseChartWidget> {
  int _selectedTab = 0; // 0: Income vs Expenses, 1: Spending Breakdown

  final List<Color> _palette = const [
    Color(0xFF6366F1), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Crimson
    Color(0xFFA855F7), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF3B82F6), // Blue
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Segment Switcher
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 20,
                  color: DesignColors.secondaryDark,
                ),
                const SizedBox(width: 8),
                Text(
                  'Finance Analytics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                ),
              ],
            ),
            // Segment Switcher
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabButton(
                    index: 0,
                    label: 'Cash Flow',
                    icon: Icons.compare_arrows_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _buildTabButton(
                    index: 1,
                    label: 'Spending',
                    icon: Icons.pie_chart_outline_rounded,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Main Content Card
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: _selectedTab == 0
              ? _buildIncomeVsExpensesView(context, isDark)
              : _buildSpendingBreakdownView(context, isDark),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTab != index) {
          setState(() => _selectedTab = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignColors.secondaryDark
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected
                  ? Colors.white
                  : (isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeVsExpensesView(BuildContext context, bool isDark) {
    final income = widget.totalIncome;
    final expenses = widget.totalExpenses;
    final hasData = income > 0 || expenses > 0;

    if (!hasData) {
      return _buildEmptyState(
        isDark: isDark,
        icon: Icons.bar_chart_rounded,
        title: 'No Cash Flow Activity Yet',
        subtitle: 'Log income or expenses in Finance to unlock cash flow comparison.',
      );
    }

    final net = income - expenses;
    final isSurplus = net >= 0;
    final maxY = max(income, expenses) * 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Income vs. Expenses',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
                fontFamily: 'Poppins',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (isSurplus ? DesignColors.positiveGreenDark : DesignColors.errorDark)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${isSurplus ? "+" : "-"}₹${net.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSurplus ? DesignColors.positiveGreenDark : DesignColors.errorDark,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: maxY <= 0 ? 100 : maxY,
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isInc = group.x == 0;
                    return BarTooltipItem(
                      '${isInc ? "Income" : "Expenses"}\n₹${rod.toY.toStringAsFixed(0)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final isInc = value.toInt() == 0;
                      final label = isInc ? 'Income' : 'Expenses';
                      final color = isInc ? DesignColors.positiveGreenDark : const Color(0xFFF97316);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 0 ? (maxY / 3) : 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: income,
                      color: DesignColors.positiveGreenDark,
                      width: 32,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: expenses,
                      color: const Color(0xFFF97316),
                      width: 32,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Mini Legend with stats
        Row(
          children: [
            Expanded(
              child: _buildCashFlowLegendItem(
                label: 'Income',
                amount: income,
                color: DesignColors.positiveGreenDark,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCashFlowLegendItem(
                label: 'Expenses',
                amount: expenses,
                color: const Color(0xFFF97316),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCashFlowLegendItem({
    required String label,
    required double amount,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                fontFamily: 'Poppins',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdownView(BuildContext context, bool isDark) {
    if (widget.data.isEmpty) {
      return _buildEmptyState(
        isDark: isDark,
        icon: Icons.show_chart_rounded,
        title: 'No Spending Data Yet',
        subtitle: 'Add your first expense in Finance to unlock automated category visualizations.',
      );
    }

    final totalSpent = widget.data.fold(0.0, (sum, item) => sum + item.value);

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 36,
                  sections: widget.data.asMap().entries.map((e) {
                    final color = _palette[e.key % _palette.length];
                    final pct = totalSpent > 0 ? (e.value.value / totalSpent * 100).round() : 0;
                    return PieChartSectionData(
                      value: e.value.value,
                      title: '$pct%',
                      color: color,
                      radius: 28,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    );
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${totalSpent.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Total Spent',
                    style: TextStyle(
                      fontSize: 9,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: widget.data.asMap().entries.map((e) {
            final color = _palette[e.key % _palette.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Text(
                  '${e.value.label} (₹${e.value.value.toInt()})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DesignColors.secondaryDark.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: DesignColors.secondaryDark, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
