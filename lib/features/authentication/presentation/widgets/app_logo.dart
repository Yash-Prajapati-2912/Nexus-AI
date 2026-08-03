import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/design_tokens/colors.dart';

/// 2026 Futuristic App Logo component with glowing AI aura backdrop and Dashboard redirection.
class AppLogo extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.size = 72,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;
    final glowColor = isDark ? DesignColors.accentPurpleDark.withOpacity(0.4) : DesignColors.primaryLight.withOpacity(0.25);

    Widget content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: size * 0.48,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => context.go(RouteNames.dashboard),
        child: content,
      ),
    );
  }
}


