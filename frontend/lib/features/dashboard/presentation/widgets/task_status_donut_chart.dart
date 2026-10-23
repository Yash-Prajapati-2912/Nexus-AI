import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../../planner/domain/entities/task_entity.dart';

class TaskStatusDonutChart extends StatefulWidget {
  final List<TaskEntity> tasks;

  const TaskStatusDonutChart({super.key, required this.tasks});

  @override
  State<TaskStatusDonutChart> createState() => _TaskStatusDonutChartState();
}

class _TaskStatusDonutChartState extends State<TaskStatusDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.tasks.length;
    final completed = widget.tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgress = widget.tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final pending = widget.tasks.where((t) => t.status == TaskStatus.pending).length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.donut_large_rounded,
                  size: 20,
                  color: DesignColors.primaryDark,
                ),
                const SizedBox(width: 8),
                Text(
                  'Task Distribution',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: DesignColors.primaryDark.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total: $total',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: DesignColors.primaryDark,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (total == 0)
                        PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 36,
                            sections: [
                              PieChartSectionData(
                                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                                value: 1,
                                title: '',
                                radius: 24,
                              ),
                            ],
                          ),
                        )
                      else
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4,
                            centerSpaceRadius: 34,
                            sections: _buildSections(completed, inProgress, pending),
                          ),
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      context,
                      color: DesignColors.positiveGreenDark,
                      label: 'Completed',
                      count: completed,
                      total: total,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      context,
                      color: DesignColors.primaryDark,
                      label: 'In Progress',
                      count: inProgress,
                      total: total,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      context,
                      color: const Color(0xFFF59E0B),
                      label: 'Pending',
                      count: pending,
                      total: total,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(int completed, int inProgress, int pending) {
    final sections = <PieChartSectionData>[];
    int sectionIndex = 0;

    if (completed > 0) {
      sections.add(
        PieChartSectionData(
          color: DesignColors.positiveGreenDark,
          value: completed.toDouble(),
          title: '$completed',
          radius: touchedIndex == sectionIndex ? 28 : 22,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      );
      sectionIndex++;
    }

    if (inProgress > 0) {
      sections.add(
        PieChartSectionData(
          color: DesignColors.primaryDark,
          value: inProgress.toDouble(),
          title: '$inProgress',
          radius: touchedIndex == sectionIndex ? 28 : 22,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      );
      sectionIndex++;
    }

    if (pending > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFFF59E0B),
          value: pending.toDouble(),
          title: '$pending',
          radius: touchedIndex == sectionIndex ? 28 : 22,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
    required int count,
    required int total,
    required bool isDark,
  }) {
    final percentage = total > 0 ? ((count / total) * 100).round() : 0;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : DesignColors.textPrimaryLight,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($percentage%)',
          style: TextStyle(
            fontSize: 10,
            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
