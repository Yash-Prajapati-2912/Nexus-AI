import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';

class TaskPriorityChartWidget extends StatelessWidget {
  final int highPriorityCount;
  final int mediumPriorityCount;
  final int lowPriorityCount;

  const TaskPriorityChartWidget({
    super.key,
    this.highPriorityCount = 0,
    this.mediumPriorityCount = 0,
    this.lowPriorityCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = [highPriorityCount, mediumPriorityCount, lowPriorityCount]
        .reduce((a, b) => a > b ? a : b);
    final maxScale = maxVal > 0 ? maxVal : 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              size: 20,
              color: DesignColors.primaryDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Workload Priority Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPriorityBar(
                context,
                label: 'URGENT / HIGH',
                count: highPriorityCount,
                maxScale: maxScale,
                color: DesignColors.errorDark,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildPriorityBar(
                context,
                label: 'MEDIUM',
                count: mediumPriorityCount,
                maxScale: maxScale,
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildPriorityBar(
                context,
                label: 'LOW',
                count: lowPriorityCount,
                maxScale: maxScale,
                color: DesignColors.secondaryDark,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBar(
    BuildContext context, {
    required String label,
    required int count,
    required int maxScale,
    required Color color,
    required bool isDark,
  }) {
    final factor = maxScale > 0 ? (count / maxScale).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth * factor;
              return Stack(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  if (count > 0)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: barWidth < 12 ? 12 : barWidth,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : DesignColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
