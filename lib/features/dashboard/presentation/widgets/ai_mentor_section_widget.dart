import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../domain/entities/ai_insight_entity.dart';

class AiMentorSectionWidget extends StatelessWidget {
  final AiInsightEntity insight;

  const AiMentorSectionWidget({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleText = insight.title.isNotEmpty ? insight.title : 'AI Operational Insight';
    final insightBody = insight.insight.isNotEmpty
        ? insight.insight
        : 'Based on your recent workload and completion rates, keeping focus on urgent tasks will maximize weekly progress.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  NexusLogoMark(
                    size: 20,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nexus AI Insight',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push(RouteNames.aiMentor),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'Ask Mentor',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.primaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: DesignColors.primaryDark),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: DesignColors.primaryDark.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : DesignColors.textPrimaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insightBody,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FocusActionChip(
                          label: 'Discuss with AI',
                          icon: Icons.smart_toy_rounded,
                          isPrimary: true,
                          onTap: () => context.push(
                            '${RouteNames.aiMentorConversation}?prompt=${Uri.encodeComponent("Explain this insight: $titleText - $insightBody")}',
                          ),
                        ),
                        _FocusActionChip(
                          label: 'View Tasks',
                          icon: Icons.task_alt_rounded,
                          onTap: () => context.push(RouteNames.planner),
                        ),
                        _FocusActionChip(
                          label: 'View Finance',
                          icon: Icons.account_balance_wallet_rounded,
                          onTap: () => context.push(RouteNames.finance),
                        ),
                      ],
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
}

class _FocusActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _FocusActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.12);
    final bgColor = isPrimary
        ? primaryColor
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9));
    final fgColor = isPrimary
        ? Colors.white
        : (isDark ? Colors.white70 : const Color(0xFF334155));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: isPrimary
            ? primaryColor.withValues(alpha: 0.9)
            : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPrimary ? primaryColor : borderColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: fgColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fgColor,
                  fontFamily: 'Poppins',
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
