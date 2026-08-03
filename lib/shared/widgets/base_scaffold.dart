import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/design_tokens/colors.dart';
import 'modern_bottom_navbar.dart';

/// Custom FloatingActionButtonLocation positioning FABs cleanly above the floating navbar.
class FloatingWithNavbarLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation baseLocation;
  final double bottomOffsetY;

  const FloatingWithNavbarLocation({
    this.baseLocation = FloatingActionButtonLocation.endFloat,
    this.bottomOffsetY = 84.0,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset baseOffset = baseLocation.getOffset(scaffoldGeometry);
    return Offset(baseOffset.dx, baseOffset.dy - bottomOffsetY);
  }
}

/// 2026 Base Scaffold container with subtle ambient mesh backdrop and modern bottom navigation bar.
class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool showAmbientMesh;

  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.showAmbientMesh = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? DesignColors.backgroundDark : DesignColors.backgroundLight);

    final purpleMesh = isDark ? DesignColors.meshPurpleDark : DesignColors.meshPurpleLight;
    final cyanMesh = isDark ? DesignColors.meshCyanDark : DesignColors.meshCyanLight;

    Widget? effectiveNavbar = bottomNavigationBar;
    if (effectiveNavbar == null) {
      try {
        final currentPath = GoRouterState.of(context).uri.toString();
        if (currentPath.startsWith('/dashboard') ||
            currentPath.startsWith('/planner') ||
            currentPath.startsWith('/ai-planner') ||
            currentPath.startsWith('/finance') ||
            currentPath.startsWith('/ai-finance') ||
            currentPath.startsWith('/ai-mentor') ||
            currentPath.startsWith('/profile')) {
          effectiveNavbar = ModernBottomNavbar(currentRoute: currentPath);
        }
      } catch (_) {}
    }

    final FloatingActionButtonLocation? effectiveFabLocation = floatingActionButtonLocation ??
        (effectiveNavbar != null ? const FloatingWithNavbarLocation() : null);

    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: effectiveFabLocation,
      body: Stack(
        children: [
          if (showAmbientMesh) ...[
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      purpleMesh,
                      purpleMesh.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      cyanMesh,
                      cyanMesh.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: const SizedBox.expand(),
              ),
            ),
          ],
          SafeArea(bottom: false, child: body),
          if (effectiveNavbar != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: effectiveNavbar,
            ),
        ],
      ),
    );
  }
}


