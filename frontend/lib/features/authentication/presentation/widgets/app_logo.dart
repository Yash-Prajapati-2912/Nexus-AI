import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../../../theme/design_tokens/colors.dart';

/// Branded App Logo component using the official Nexus N symbol.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final bool showTagline;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showWordmark = false,
    this.showTagline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glowColor = isDark
        ? const Color(0xFF7C6CFF).withValues(alpha: 0.35)
        : const Color(0xFF4F8CFF).withValues(alpha: 0.25);

    Widget symbolMark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF7C6CFF), Color(0xFF4FD1FF)],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
          ),
          child: Center(
            child: NexusLogoMark(
              size: size * 0.58,
              isDark: isDark,
            ),
          ),
        ),
      ),
    );

    Widget content = showWordmark
        ? NexusLogo(
            variant: LogoVariant.full,
            markSize: size,
            fontSize: size * 0.45,
            showTagline: showTagline,
            logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
          )
        : symbolMark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => context.go(RouteNames.dashboard),
        child: content,
      ),
    );
  }
}
