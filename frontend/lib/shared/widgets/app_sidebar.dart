import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/route_names.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';
import '../branding/nexus_logo.dart';

class SidebarNavItem {
  final String label;
  final String category;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const SidebarNavItem({
    required this.label,
    required this.category,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

/// 2026 Sleek Desktop & Tablet Navigation Sidebar for Nexus AI.
class AppSidebar extends StatefulWidget {
  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  static const List<SidebarNavItem> items = [
    SidebarNavItem(
      label: 'Dashboard',
      category: 'Overview',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      route: RouteNames.dashboard,
    ),
    SidebarNavItem(
      label: 'Planner & Tasks',
      category: 'Academic',
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt_rounded,
      route: RouteNames.planner,
    ),
    SidebarNavItem(
      label: 'Finance Studio',
      category: 'Financial',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      route: RouteNames.finance,
    ),
    SidebarNavItem(
      label: 'AI Mentor Agent',
      category: 'Intelligence',
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
      route: RouteNames.aiMentorHome,
    ),
    SidebarNavItem(
      label: 'Profile & Settings',
      category: 'Account',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: RouteNames.profile,
    ),
  ];

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  int _getSelectedIndex() {
    if (widget.currentRoute.startsWith(RouteNames.planner) ||
        widget.currentRoute.startsWith('/ai-planner')) {
      return 1;
    }
    if (widget.currentRoute.startsWith(RouteNames.finance) ||
        widget.currentRoute.startsWith('/ai-finance')) {
      return 2;
    }
    if (widget.currentRoute.startsWith(RouteNames.aiMentor)) {
      return 3;
    }
    if (widget.currentRoute.startsWith(RouteNames.profile) ||
        widget.currentRoute.startsWith('/settings')) {
      return 4;
    }
    return 0; // Default to Dashboard
  }

  void _onItemTapped(int index) {
    final targetRoute = AppSidebar.items[index].route;
    if (widget.currentRoute != targetRoute) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = _getSelectedIndex();

    final backgroundColor = isDark ? DesignColors.surfaceElevatedDark : DesignColors.surfaceElevatedLight;
    final borderColor = isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight;
    final primaryAccent = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final textPrimary = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final textSecondary = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;
    final activeBg = isDark ? DesignColors.surfaceSelectedDark : DesignColors.surfaceSelectedLight;

    final double width = widget.isCollapsed ? 76.0 : 256.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            // Branding Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 12.0 : 16.0,
                vertical: 16.0,
              ),
              child: widget.isCollapsed
                  ? Center(
                      child: NexusLogoMark(
                        size: 32,
                        isDark: isDark,
                      ),
                    )
                  : Row(
                      children: [
                        NexusLogoMark(
                          size: 36,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NEXUS AI',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                  height: 1.1,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Workspace',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 12),

            // Navigation Items List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: widget.isCollapsed ? 10.0 : 12.0),
                itemCount: AppSidebar.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = AppSidebar.items[index];
                  final isSelected = selectedIndex == index;

                  return InkWell(
                    onTap: () => _onItemTapped(index),
                    borderRadius: DesignRadius.md,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isCollapsed ? 0.0 : 12.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? activeBg : Colors.transparent,
                        borderRadius: DesignRadius.md,
                      ),
                      child: Row(
                        mainAxisAlignment: widget.isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 19,
                            color: isSelected ? primaryAccent : textSecondary,
                          ),
                          if (!widget.isCollapsed) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.label,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? textPrimary : textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryAccent,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Footer Section
            if (widget.onToggleCollapse != null) ...[
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                        size: 20,
                      ),
                      color: textSecondary,
                      onPressed: widget.onToggleCollapse,
                      tooltip: widget.isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
                    ),
                  ],
                ),
              ),
            ] else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
