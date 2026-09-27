import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/chart_data_entity.dart';

class WeeklyStudyChartWidget extends StatelessWidget {
  final List<ChartDataPoint> data;

  const WeeklyStudyChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.equalizer_rounded,
              size: 20,
              color: DesignColors.secondaryDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Weekly Focus Hours',
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
                  Icons.timer_outlined,
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Log study sessions in Planner to visualize your weekly activity hours.',
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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
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
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.value,
                          color: DesignColors.secondaryDark,
                          width: 14,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
