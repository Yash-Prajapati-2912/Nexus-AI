import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

enum CardSurfaceLevel { primary, secondary, outlined }

/// 2026 Modern Refined Surface Card Container.
/// Supports Light/Dark modes, surface hierarchy, and web hover microinteractions.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final VoidCallback? onTap;
  final CardSurfaceLevel surfaceLevel;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 12.0,
    this.onTap,
    this.surfaceLevel = CardSurfaceLevel.primary,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveRadius = widget.borderRadius ?? DesignRadius.lg;

    Color backgroundColor;
    switch (widget.surfaceLevel) {
      case CardSurfaceLevel.primary:
        backgroundColor = isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight;
        break;
      case CardSurfaceLevel.secondary:
        backgroundColor = isDark ? DesignColors.surfaceElevatedDark : DesignColors.surfaceElevatedLight;
        break;
      case CardSurfaceLevel.outlined:
        backgroundColor = Colors.transparent;
        break;
    }

    if (_isHovered && widget.onTap != null) {
      backgroundColor = isDark
          ? backgroundColor.withValues(alpha: 0.95)
          : backgroundColor.withValues(alpha: 0.95);
    }

    final borderColor = _isHovered && widget.onTap != null
        ? (isDark ? DesignColors.primaryDark.withValues(alpha: 0.4) : DesignColors.primaryLight.withValues(alpha: 0.3))
        : (isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight);

    final shadows = isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered && widget.onTap != null ? 0.35 : 0.22),
              blurRadius: _isHovered && widget.onTap != null ? 20 : 14,
              spreadRadius: -2,
              offset: const Offset(0, 4),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0x0A0F172A),
              blurRadius: _isHovered && widget.onTap != null ? 16 : 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ];

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: effectiveRadius,
            child: content,
          ),
        ),
      );
    }

    if (widget.blur > 0) {
      content = ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: content,
        ),
      );
    }

    if (widget.margin != null) {
      content = Padding(padding: widget.margin!, child: content);
    }

    return content;
  }
}

