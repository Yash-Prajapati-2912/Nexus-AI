import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/route_names.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Modern Desktop Top Header with contextual search, notifications, and profile quick triggers.
class DesktopHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;

  const DesktopHeader({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
  });

  String _getAutomaticTitle(String path) {
    if (path.startsWith(RouteNames.planner) || path.startsWith('/ai-planner')) {
      return 'Tasks & Academic Planner';
    }
    if (path.startsWith(RouteNames.finance) || path.startsWith('/ai-finance')) {
      return 'Financial Intelligence Studio';
    }
    if (path.startsWith(RouteNames.aiMentor)) {
      return 'AI Mentor Agent';
    }
    if (path.startsWith(RouteNames.profile) || path.startsWith('/settings')) {
      return 'Profile & Account Settings';
    }
    return 'Nexus AI Workspace';
  }

  String _getAutomaticSubtitle(String path) {
    if (path.startsWith(RouteNames.planner) || path.startsWith('/ai-planner')) {
      return 'Manage assignments, exams, and AI-optimized workload';
    }
    if (path.startsWith(RouteNames.finance) || path.startsWith('/ai-finance')) {
      return 'Track expenses, budgets, savings, and AI financial forecasts';
    }
    if (path.startsWith(RouteNames.aiMentor)) {
      return 'Interactive AI guidance, tutoring, and personalized recommendations';
    }
    if (path.startsWith(RouteNames.profile) || path.startsWith('/settings')) {
      return 'Customize preferences, security, appearance, and account profile';
    }
    return 'Welcome back to your AI productivity workspace';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPath = GoRouterState.of(context).uri.toString();

    final displayTitle = title ?? _getAutomaticTitle(currentPath);
    final displaySubtitle = subtitle ?? _getAutomaticSubtitle(currentPath);

    final borderColor = isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight;
    final textPrimary = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final textSecondary = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final iconBg = isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight;

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? DesignColors.backgroundDark : DesignColors.backgroundLight,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Contextual Page Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  displaySubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Action Widgets / Quick Controls
          if (actions != null) ...actions!,
          if (actions == null) ...[
            // Notifications Trigger
            Container(
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: DesignRadius.md,
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 20),
                color: textPrimary,
                tooltip: 'Notifications',
                onPressed: () => context.push(RouteNames.notificationsCenter),
              ),
            ),
            const SizedBox(width: 10),

            // Settings Trigger
            Container(
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: DesignRadius.md,
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, size: 20),
                color: textPrimary,
                tooltip: 'Settings',
                onPressed: () => context.push(RouteNames.settings),
              ),
            ),
            const SizedBox(width: 10),

            // User Profile Quick Avatar Button
            InkWell(
              onTap: () => context.push(RouteNames.profileHome),
              borderRadius: DesignRadius.full,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: DesignColors.primaryDark, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: DesignColors.primaryDark,
                  child: Icon(Icons.person_rounded, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72.0);
}
