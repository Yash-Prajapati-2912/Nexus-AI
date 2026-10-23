import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/design_tokens/colors.dart';
import '../../theme/design_tokens/radius.dart';

/// 2026 Modern Gradient Primary Button Widget.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? DesignColors.primaryGradientDark
        : DesignColors.primaryGradientLight;

    final shadowColor = isDark
        ? DesignColors.accentPurpleDark.withValues(alpha: _isHovered ? 0.45 : 0.3)
        : DesignColors.primaryLight.withValues(alpha: _isHovered ? 0.35 : 0.25);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onPressed != null && !widget.isLoading
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : (_isHovered && widget.onPressed != null && !widget.isLoading ? 1.01 : 1.0),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: widget.onPressed != null && !widget.isLoading ? gradient : null,
            color: widget.onPressed == null
                ? (isDark ? Colors.white12 : Colors.black12)
                : (_isHovered ? null : null),
            borderRadius: DesignRadius.md,
            boxShadow: widget.onPressed != null && !widget.isLoading
                ? [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: _isHovered ? 16 : 12,
                      offset: Offset(0, _isHovered ? 6 : 4),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              borderRadius: DesignRadius.md,
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.label,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



