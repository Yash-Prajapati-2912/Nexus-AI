import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/design_tokens/colors.dart';
import '../branding/nexus_logo.dart';

/// 2026 Modern Branded Loading Experience for Nexus AI.
/// - Centered horizontally and vertically in usable viewport
/// - Nexus AI N gradient mark + smooth pulsing orbit aura
/// - Contextual loading indicator text
class NexusLoadingWidget extends StatefulWidget {
  final String message;
  final double iconSize;

  const NexusLoadingWidget({
    super.key,
    this.message = 'Loading...',
    this.iconSize = 36.0,
  });

  @override
  State<NexusLoadingWidget> createState() => _NexusLoadingWidgetState();
}

class _NexusLoadingWidgetState extends State<NexusLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final textSecondary = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer subtle glowing aura
                    Transform.scale(
                      scale: _scaleAnimation.value * 1.35,
                      child: Container(
                        width: widget.iconSize * 1.8,
                        height: widget.iconSize * 1.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              primaryAccent.withValues(alpha: _opacityAnimation.value * 0.4),
                              const Color(0xFF06B6D4).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Rotating ambient ring
                    SizedBox(
                      width: widget.iconSize * 1.7,
                      height: widget.iconSize * 1.7,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                        backgroundColor: primaryAccent.withValues(alpha: 0.12),
                      ),
                    ),

                    // Centered Nexus N Icon Mark
                    Container(
                      width: widget.iconSize * 1.3,
                      height: widget.iconSize * 1.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF0B0D12) : const Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: primaryAccent.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: NexusLogoMark(
                          size: widget.iconSize * 0.75,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              widget.message,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textSecondary,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
