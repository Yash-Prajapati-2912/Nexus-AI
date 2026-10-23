import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/productivity_stats_entity.dart';

class ProductivitySectionWidget extends StatelessWidget {
  final ProductivityStatsEntity stats;

  const ProductivitySectionWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              size: 20,
              color: Color(0xFFF59E0B),
            ),
            const SizedBox(width: 8),
            Text(
              'Productivity & Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Study Streak',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stats.streakDays} Days',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Daily focus target met',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Study Hours',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Icon(Icons.timer_rounded, color: DesignColors.primaryDark, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stats.studyHoursThisWeek} hrs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Logged this week',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
