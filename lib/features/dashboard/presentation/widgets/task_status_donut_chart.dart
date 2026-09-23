import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../shared/design_system/widgets/cards/app_card.dart';
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
            Text(
              'Task Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total: $total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 140,
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
                                  color: isDark ? Colors.white10 : Colors.black12,
                                  value: 1,
                                  title: '',
                                  radius: 26,
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
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 4,
                              centerSpaceRadius: 36,
                              sections: _buildSections(completed, inProgress, pending),
                            ),
                          ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white60 : Colors.black54,
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
                        color: const Color(0xFF10B981),
                        label: 'Completed',
                        count: completed,
                        total: total,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildLegendItem(
                        context,
                        color: const Color(0xFF3B82F6),
                        label: 'In Progress',
                        count: inProgress,
                        total: total,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
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
          color: const Color(0xFF10B981),
          value: completed.toDouble(),
          title: '$completed',
          radius: touchedIndex == sectionIndex ? 30 : 24,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      sectionIndex++;
    }

    if (inProgress > 0) {
      sections.add(
        PieChartSectionData(
          color: const Color(0xFF3B82F6),
          value: inProgress.toDouble(),
          title: '$inProgress',
          radius: touchedIndex == sectionIndex ? 30 : 24,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
          radius: touchedIndex == sectionIndex ? 30 : 24,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '($percentage%)',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
        ),
      ],
    );
  }
}
