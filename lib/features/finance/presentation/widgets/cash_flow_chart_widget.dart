import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CashFlowChartWidget extends StatefulWidget {
  final List<double> incomeSeries;
  final List<double> expenseSeries;
  final List<String> labels;
  final String currencySymbol;
  final Function(String timeframe)? onTimeframeChanged;

  const CashFlowChartWidget({
    super.key,
    required this.incomeSeries,
    required this.expenseSeries,
    this.labels = const [],
    this.currencySymbol = '₹',
    this.onTimeframeChanged,
  });

  @override
  State<CashFlowChartWidget> createState() => _CashFlowChartWidgetState();
}

class _CashFlowChartWidgetState extends State<CashFlowChartWidget> {
  String _selectedTimeframe = '1M';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasData = (widget.incomeSeries.any((v) => v > 0) || widget.expenseSeries.any((v) => v > 0));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 440;
                final titleColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cash Flow Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('Income vs. Expenses', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                );

                final selector = SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '7D', label: Text('7D', style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: '1M', label: Text('1M', style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: '3M', label: Text('3M', style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: '6M', label: Text('6M', style: TextStyle(fontSize: 11))),
                  ],
                  selected: {_selectedTimeframe},
                  onSelectionChanged: (set) {
                    setState(() => _selectedTimeframe = set.first);
                    if (widget.onTimeframeChanged != null) {
                      widget.onTimeframeChanged!(set.first);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF6366F1);
                      }
                      return isDark ? const Color(0xFF1E293B) : Colors.grey.shade200;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return isDark ? Colors.white70 : Colors.black87;
                    }),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                  ),
                );

                if (isSmall) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleColumn,
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: selector,
                      ),
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleColumn,
                    selector,
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (!hasData)
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
                    Icon(Icons.show_chart_rounded, size: 40, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text(
                      'Add more transactions to unlock your cash-flow trend.',
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 24,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if ((val - idx).abs() < 0.001 && idx >= 0 && idx < widget.labels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  widget.labels[idx],
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
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
                            return LineTooltipItem(
                              '${isIncome ? "Income" : "Expense"}: ${widget.currencySymbol}${spot.y.toStringAsFixed(0)}',
                              TextStyle(
                                color: isIncome ? const Color(0xFF10B981) : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      // Income bar line (Emerald green)
                      LineChartBarData(
                        spots: List.generate(
                          widget.incomeSeries.length,
                          (i) => FlSpot(i.toDouble(), widget.incomeSeries[i]),
                        ),
                        isCurved: widget.incomeSeries.length > 1,
                        color: const Color(0xFF10B981),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF10B981).withAlpha(25),
                        ),
                      ),
                      // Expense bar line (Red accent)
                      LineChartBarData(
                        spots: List.generate(
                          widget.expenseSeries.length,
                          (i) => FlSpot(i.toDouble(), widget.expenseSeries[i]),
                        ),
                        isCurved: widget.expenseSeries.length > 1,
                        color: Colors.redAccent,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.redAccent.withAlpha(25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegendItem(color: Color(0xFF10B981), label: 'Income'),
                SizedBox(width: 24),
                _ChartLegendItem(color: Colors.redAccent, label: 'Expenses'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
