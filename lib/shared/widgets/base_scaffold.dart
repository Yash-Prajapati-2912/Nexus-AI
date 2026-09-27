import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/design_tokens/colors.dart';
import 'app_sidebar.dart';
import 'desktop_header.dart';
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

/// 2026 Responsive Application Shell for Nexus AI.
/// - Desktop (>= 1100px): Left SaaS Sidebar + Top Header + Max-width Content
/// - Tablet (600px - 1099px): Compact Collapsible Navigation Rail + Top Header + Content
/// - Mobile (< 600px): Top Header + Content + Floating Capsule Bottom Navbar
class BaseScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool showAmbientMesh;
  final bool constrainDesktopWidth;
  final double maxDesktopWidth;
  final String? title;
  final String? subtitle;

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
    this.constrainDesktopWidth = true,
    this.maxDesktopWidth = 1240.0,
    this.title,
    this.subtitle,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _isSidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ?? (isDark ? DesignColors.backgroundDark : DesignColors.backgroundLight);
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1100;
    final isTablet = width >= 600 && width < 1100;
    final isMobile = width < 600;

    final purpleMesh = isDark ? DesignColors.meshPurpleDark : DesignColors.meshPurpleLight;
    final cyanMesh = isDark ? DesignColors.meshCyanDark : DesignColors.meshCyanLight;

    String currentPath = '/dashboard';
    try {
      currentPath = GoRouterState.of(context).uri.toString();
    } catch (_) {}

    Widget? effectiveNavbar = widget.bottomNavigationBar;
    if (isMobile && effectiveNavbar == null) {
      if (currentPath.startsWith('/dashboard') ||
          currentPath.startsWith('/planner') ||
          currentPath.startsWith('/ai-planner') ||
          currentPath.startsWith('/finance') ||
          currentPath.startsWith('/ai-finance') ||
          currentPath.startsWith('/ai-mentor') ||
          currentPath.startsWith('/profile')) {
        effectiveNavbar = ModernBottomNavbar(currentRoute: currentPath);
      }
    }

    final FloatingActionButtonLocation? effectiveFabLocation = widget.floatingActionButtonLocation ??
        (effectiveNavbar != null ? const FloatingWithNavbarLocation() : null);

    final PreferredSizeWidget? effectiveHeader = widget.appBar ??
        ((isDesktop || isTablet)
            ? DesktopHeader(
                title: widget.title,
                subtitle: widget.subtitle,
              )
            : null);

    Widget mainContent = widget.body;
    if ((isDesktop || isTablet) && widget.constrainDesktopWidth) {
      mainContent = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxDesktopWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: widget.body,
          ),
        ),
      );
    }

    Widget bodyLayout;
    if (isDesktop || isTablet) {
      final collapsedState = isTablet ? true : _isSidebarCollapsed;
      bodyLayout = Row(
        children: [
          AppSidebar(
            currentRoute: currentPath,
            isCollapsed: collapsedState,
            onToggleCollapse: isDesktop ? _toggleSidebar : null,
          ),
          Expanded(
            child: Column(
              children: [
                if (effectiveHeader != null) effectiveHeader,
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      if (effectiveNavbar != null) {
        bodyLayout = Padding(
          padding: const EdgeInsets.only(bottom: 84.0),
          child: mainContent,
        );
      } else {
        bodyLayout = mainContent;
      }
    }

    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      appBar: isMobile ? widget.appBar : null,
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: effectiveFabLocation,
      body: Stack(
        children: [
          if (widget.showAmbientMesh) ...[
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
                      purpleMesh.withValues(alpha: 0.0),
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
                      cyanMesh.withValues(alpha: 0.0),
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
          SafeArea(bottom: false, child: bodyLayout),
          if (isMobile && effectiveNavbar != null)
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




