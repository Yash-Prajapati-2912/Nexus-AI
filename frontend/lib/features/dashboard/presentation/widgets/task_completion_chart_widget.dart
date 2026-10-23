import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/chart_data_entity.dart';

class TaskCompletionChartWidget extends StatelessWidget {
  final List<ChartDataPoint> data;

  const TaskCompletionChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.trending_up_rounded,
              size: 20,
              color: DesignColors.primaryDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Weekly Workload Activity Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (data.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Complete tasks during the week to generate workload activity trend lines.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                data[idx].label,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? DesignColors.textSecondaryDark
                                      : DesignColors.textSecondaryLight,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                          .toList(),
                      isCurved: true,
                      color: DesignColors.primaryDark,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4,
                          color: DesignColors.primaryDark,
                          strokeWidth: 2,
                          strokeColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            DesignColors.primaryDark.withValues(alpha: 0.25),
                            DesignColors.primaryDark.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
