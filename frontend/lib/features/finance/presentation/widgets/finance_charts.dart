import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/financial_report.dart';

class FinanceCharts extends StatelessWidget {
  final FinancialReport report;

  const FinanceCharts({super.key, required this.report});

  Color _parseColor(String colorHex, int index, ThemeData theme) {
    const defaultPalette = [
      Color(0xFFEF4444),
      Color(0xFF3B82F6),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
      Color(0xFFF97316),
    ];
    try {
      final hex = colorHex.replaceAll('#', '').trim();
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return defaultPalette[index % defaultPalette.length];
  }

  String _formatDateLabel(String rawDate, String timeframe, int index) {
    if (rawDate.isEmpty) return '$index';
    try {
      final parts = rawDate.split('-');
      if (timeframe == 'YEARLY') {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        if (parts.length >= 2) {
          final m = int.tryParse(parts[1]) ?? 1;
          if (m >= 1 && m <= 12) return months[m - 1];
        }
        return rawDate;
      }
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]) ?? 2026;
        final month = int.tryParse(parts[1]) ?? 1;
        final day = int.tryParse(parts[2]) ?? 1;
        final dt = DateTime(year, month, day);

        if (timeframe == 'WEEKLY') {
          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          return days[(dt.weekday - 1).clamp(0, 6)];
        }
        if (timeframe == 'MONTHLY') {
          return '$day';
        }
        if (timeframe == 'DAILY') {
          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          return '$day ${months[(month - 1).clamp(0, 11)]}';
        }
      }
    } catch (_) {}
    return rawDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalCategoryExpense = report.expenseBreakdown.fold(0.0, (sum, i) => sum + i.amount);
    final hasCategoryData = report.expenseBreakdown.isNotEmpty && totalCategoryExpense > 0;

    final points = report.cashFlowPoints;
    final hasCashFlowData = points.isNotEmpty
        ? (points.any((p) => p.inflow > 0 || p.outflow > 0))
        : (report.cashFlowSeries.any((v) => v != 0) || report.totalIncome > 0 || report.totalExpense > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense Breakdown by Category',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (!hasCategoryData)
          Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline_rounded, size: 36, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'No expense records for this timeframe.',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          )
        else
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 52,
                            sections: List.generate(report.expenseBreakdown.length, (idx) {
                              final item = report.expenseBreakdown[idx];
                              final col = _parseColor(item.colorHex, idx, theme);
                              final pct = totalCategoryExpense > 0
                                  ? (item.amount / totalCategoryExpense) * 100
                                  : 0.0;
                              return PieChartSectionData(
                                color: col,
                                value: item.amount,
                                title: pct >= 5 ? '${pct.toStringAsFixed(0)}%' : '',
                                radius: 36,
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${totalCategoryExpense.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Total Spent',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: List.generate(report.expenseBreakdown.length, (idx) {
                      final item = report.expenseBreakdown[idx];
                      final col = _parseColor(item.colorHex, idx, theme);
                      final pct = totalCategoryExpense > 0
                          ? (item.amount / totalCategoryExpense) * 100
                          : 0.0;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: col, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.categoryName} ₹${item.amount.toStringAsFixed(2)} (${pct.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cash Flow Trend',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Row(
              children: [
                _LegendDot(color: Color(0xFF10B981), label: 'Income'),
                SizedBox(width: 14),
                _LegendDot(color: Color(0xFFEF4444), label: 'Expense'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasCashFlowData)
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.show_chart_rounded, size: 36, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'No cash flow transactions recorded for this timeframe.',
                  style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          )
        else
          Card(
            elevation: 0,
            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 16, top: 16, bottom: 12),
              child: SizedBox(
                height: 220,
                child: Builder(
                  builder: (context) {
                    final isCurved = points.length > 1;

                    // Calculate safe Y bounds
                    double minY = 0.0;
                    double maxY = 0.0;

                    if (points.isNotEmpty) {
                      for (final p in points) {
                        if (p.inflow > maxY) maxY = p.inflow;
                        if (p.outflow > maxY) maxY = p.outflow;
                        if (p.net < minY) minY = p.net;
                      }
                    } else {
                      for (final val in report.cashFlowSeries) {
                        if (val > maxY) maxY = val;
                        if (val < minY) minY = val;
                      }
                    }

                    if (maxY == 0 && minY == 0) {
                      maxY = 100.0;
                    } else if (maxY == minY) {
                      maxY = minY + 10.0;
                    } else {
                      maxY = (maxY * 1.15).ceilToDouble();
                    }

                    final incomeSpots = points.isNotEmpty
                        ? List.generate(points.length, (i) => FlSpot(i.toDouble(), points[i].inflow))
                        : (report.totalIncome > 0
                            ? [FlSpot(0, report.totalIncome)]
                            : [const FlSpot(0, 0)]);

                    final expenseSpots = points.isNotEmpty
                        ? List.generate(points.length, (i) => FlSpot(i.toDouble(), points[i].outflow))
                        : (report.totalExpense > 0
                            ? [FlSpot(0, report.totalExpense)]
                            : [const FlSpot(0, 0)]);

                    return LineChart(
                      LineChartData(
                        minY: minY < 0 ? minY : 0,
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (val) => FlLine(
                            color: isDark ? Colors.white10 : Colors.black12,
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (val, meta) {
                                if (val < 0) return const SizedBox.shrink();
                                if (val >= 1000) {
                                  return Text(
                                    '${(val / 1000).toStringAsFixed(0)}k',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                }
                                return Text(
                                  val.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 24,
                              getTitlesWidget: (val, meta) {
                                final idx = val.toInt();
                                if ((val - idx).abs() > 0.001 || idx < 0 || idx >= points.length) {
                                  return const SizedBox.shrink();
                                }

                                if (report.timeframe == 'MONTHLY' && points.length > 10) {
                                  final step = (points.length / 5).ceil();
                                  if (idx != 0 && idx != points.length - 1 && idx % step != 0) {
                                    return const SizedBox.shrink();
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    _formatDateLabel(points[idx].date, report.timeframe, idx),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                final isIncome = spot.barIndex == 0;
                                final name = isIncome ? 'Income' : 'Expense';
                                final color = isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                                return LineTooltipItem(
                                  '$name: ₹${spot.y.toStringAsFixed(2)}',
                                  TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: [
                          // Income Bar Line (Emerald Green)
                          LineChartBarData(
                            spots: incomeSpots,
                            isCurved: isCurved,
                            color: const Color(0xFF10B981),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: points.length <= 15),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF10B981).withAlpha(25),
                            ),
                          ),
                          // Expense Bar Line (Red)
                          LineChartBarData(
                            spots: expenseSpots,
                            isCurved: isCurved,
                            color: const Color(0xFFEF4444),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: points.length <= 15),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFFEF4444).withAlpha(25),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
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
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
