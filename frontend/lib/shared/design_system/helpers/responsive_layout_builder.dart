import 'package:flutter/material.dart';

/// 2026 Responsive Layout Builder and Content Constrain Helper.
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double maxContentWidth;
  final bool centerDesktopContent;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.maxContentWidth = 1240.0,
    this.centerDesktopContent = true,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1100;
  }
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) return 32.0;
    if (width >= 600) return 24.0;
    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;
        if (constraints.maxWidth >= 1100 && desktop != null) {
          content = desktop!;
        } else if (constraints.maxWidth >= 600 && tablet != null) {
          content = tablet!;
        } else {
          content = mobile;
        }

        if (constraints.maxWidth >= 1100 && centerDesktopContent) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: content,
            ),
          );
        }
        return content;
      },
    );
  }
}

