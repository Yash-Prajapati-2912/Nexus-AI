import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';

class ModernNavbarItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const ModernNavbarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

class ModernBottomNavbar extends StatelessWidget {
  final String currentRoute;

  const ModernBottomNavbar({
    super.key,
    required this.currentRoute,
  });

  static const List<ModernNavbarItem> _items = [
    ModernNavbarItem(
      label: 'Dashboard',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      route: RouteNames.dashboard,
    ),
    ModernNavbarItem(
      label: 'Tasks',
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt_rounded,
      route: RouteNames.planner,
    ),
    ModernNavbarItem(
      label: 'Finance',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      route: RouteNames.finance,
    ),
    ModernNavbarItem(
      label: 'Agent',
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
      route: RouteNames.aiMentorHome,
    ),
    ModernNavbarItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: RouteNames.profile,
    ),
  ];

  int _getSelectedIndex() {
    if (currentRoute.startsWith(RouteNames.planner) ||
        currentRoute.startsWith('/ai-planner')) {
      return 1;
    }
    if (currentRoute.startsWith(RouteNames.finance) ||
        currentRoute.startsWith('/ai-finance')) {
      return 2;
    }
    if (currentRoute.startsWith(RouteNames.aiMentor)) {
      return 3;
    }
    if (currentRoute.startsWith(RouteNames.profile) ||
        currentRoute.startsWith('/settings')) {
      return 4;
    }
    return 0; // Default to Dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    final targetRoute = _items[index].route;
    if (currentRoute != targetRoute) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = _getSelectedIndex();

    final glassTint =
        isDark ? const Color(0x06FFFFFF) : const Color(0x08FFFFFF);
    final glassBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.32)
        : Colors.white.withValues(alpha: 0.75);
    final primaryAccent =
        isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    final inactiveIconColor = isDark
        ? Colors.white.withValues(alpha: 0.60)
        : const Color(0xFF64748B).withValues(alpha: 0.85);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              height: 66,
              decoration: BoxDecoration(
                color: glassTint,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: glassBorderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: (isDark ? const Color(0xFF6366F1) : Colors.white)
                        .withValues(alpha: isDark ? 0.08 : 0.30),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Specular Diagonal Glass Reflection Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 0.45, 1.0],
                          colors: [
                            Colors.white
                                .withValues(alpha: isDark ? 0.15 : 0.35),
                            Colors.white.withValues(alpha: 0.02),
                            Colors.white
                                .withValues(alpha: isDark ? 0.08 : 0.20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Top Edge Specular Prism Reflection Line
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    height: 1.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white
                                .withValues(alpha: isDark ? 0.60 : 0.95),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Navigation Tab Items Row with Inner Horizontal Inset Padding
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_items.length, (index) {
                        final item = _items[index];
                        final isSelected = selectedIndex == index;

                        return Expanded(
                          child: InkWell(
                            onTap: () => _onItemTapped(context, index),
                            borderRadius: BorderRadius.circular(30),
                            splashColor: primaryAccent.withValues(alpha: 0.10),
                            highlightColor: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Soft Glowing Liquid Glass Active Capsule
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.fastOutSlowIn,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? const Color(0xFF6366F1)
                                                .withValues(alpha: 0.25)
                                            : Colors.white
                                                .withValues(alpha: 0.45))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isSelected
                                        ? Border.all(
                                            color: isDark
                                                ? const Color(0xFF818CF8)
                                                : Colors.white,
                                            width: 1.0,
                                          )
                                        : Border.all(
                                            color: Colors.transparent,
                                            width: 1.0),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: (isDark
                                                      ? const Color(0xFF6366F1)
                                                      : Colors.indigoAccent)
                                                  .withValues(alpha: 0.25),
                                              blurRadius: 10,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: AnimatedScale(
                                    scale: isSelected ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn,
                                    child: Icon(
                                      isSelected ? item.activeIcon : item.icon,
                                      size: 19,
                                      color: isSelected
                                          ? (isDark
                                              ? Colors.white
                                              : primaryAccent)
                                          : inactiveIconColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Typography Label
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: isSelected ? 1.0 : 0.65,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        style: TextStyle(
                                          height: 1.1,
                                          fontSize: isSelected ? 10.5 : 10.0,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                              : (isDark
                                                  ? Colors.white70
                                                  : const Color(0xFF64748B)),
                                          letterSpacing: isSelected ? 0.1 : 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
