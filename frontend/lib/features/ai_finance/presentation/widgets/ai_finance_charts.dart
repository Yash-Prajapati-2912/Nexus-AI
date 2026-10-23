import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';

class AIFinanceCharts extends StatelessWidget {
  final Forecast forecast;

  const AIFinanceCharts({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Predicted Cash Flow Trend',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    forecast.projectedCashFlowSeries.length,
                    (idx) => FlSpot(idx.toDouble(), forecast.projectedCashFlowSeries[idx]),
                  ),
                  isCurved: true,
                  color: const Color(0xFF6366F1),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF6366F1).withAlpha(35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
