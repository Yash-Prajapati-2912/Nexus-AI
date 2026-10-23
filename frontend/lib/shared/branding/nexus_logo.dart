import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogoVariant {
  /// Symbol + Text "NEXUS AI" + Optional Tagline
  full,

  /// Standalone N Mark symbol only
  markOnly,

  /// Text "NEXUS AI" only
  wordmarkOnly,

  /// Full Connected Ecosystem Lockup (N + 5 Feature Icons + Wordmark)
  ecosystem,
}

enum LogoTheme {
  /// Theme-adaptive (auto detects dark vs light)
  auto,

  /// Dark theme styling (white text, violet-blue-cyan gradient)
  dark,

  /// Light theme styling (dark slate text, violet-blue-cyan gradient)
  light,
}

/// Official Nexus AI Brand Logo Component.
class NexusLogo extends StatelessWidget {
  final LogoVariant variant;
  final LogoTheme logoTheme;
  final double markSize;
  final double fontSize;
  final bool showTagline;
  final VoidCallback? onTap;

  const NexusLogo({
    super.key,
    this.variant = LogoVariant.full,
    this.logoTheme = LogoTheme.auto,
    this.markSize = 36.0,
    this.fontSize = 20.0,
    this.showTagline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = logoTheme == LogoTheme.auto
        ? Theme.of(context).brightness == Brightness.dark
        : logoTheme == LogoTheme.dark;

    final primaryTextColor = isDark ? const Color(0xFFF5F7FA) : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    Widget content;

    switch (variant) {
      case LogoVariant.markOnly:
        content = NexusLogoMark(size: markSize, isDark: isDark);
        break;

      case LogoVariant.wordmarkOnly:
        content = _buildWordmark(primaryTextColor, fontSize, showTagline, secondaryTextColor);
        break;

      case LogoVariant.full:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NexusLogoMark(size: markSize, isDark: isDark),
            SizedBox(width: markSize * 0.3),
            _buildWordmark(primaryTextColor, fontSize, showTagline, secondaryTextColor),
          ],
        );
        break;

      case LogoVariant.ecosystem:
        content = NexusEcosystemLogoMark(
          size: markSize,
          isDark: isDark,
          showWordmark: true,
        );
        break;
    }

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildWordmark(Color textColor, double size, bool withTagline, Color taglineColor) {
    const gradient = LinearGradient(
      colors: [Color(0xFF7C6CFF), Color(0xFF4F8CFF), Color(0xFF4FD1FF)],
    );

    final title = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'NEXUS ',
          style: GoogleFonts.poppins(
            fontSize: size,
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: 0.8,
            height: 1.0,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: Text(
            'AI',
            style: GoogleFonts.poppins(
              fontSize: size,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.8,
              height: 1.0,
            ),
          ),
        ),
      ],
    );

    if (!withTagline) return title;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 3),
        Text(
          'Your life, intelligently connected.',
          style: GoogleFonts.poppins(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w500,
            color: taglineColor,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

/// Standalone Nexus N Mark Widget with high-precision CustomPainter.
class NexusLogoMark extends StatelessWidget {
  final double size;
  final bool isDark;
  final bool animated;

  const NexusLogoMark({
    super.key,
    this.size = 40.0,
    this.isDark = true,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Nexus AI Symbol',
      child: CustomPaint(
        size: Size(size, size),
        painter: _NexusMarkPainter(isDark: isDark),
      ),
    );
  }
}

class _NexusMarkPainter extends CustomPainter {
  final bool isDark;

  _NexusMarkPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // Gradient definitions
    final mainGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? const [Color(0xFF7C6CFF), Color(0xFF4F8CFF), Color(0xFF4FD1FF)]
          : const [Color(0xFF6351F5), Color(0xFF3B82F6), Color(0xFF06B6D4)],
    );

    final rect = Rect.fromLTWH(0, 0, w, h);
    final mainShader = mainGradient.createShader(rect);

    // 1. Draw Subtle Tilted Orbit Ring
    final orbitPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF7C6CFF).withValues(alpha: 0.5),
          const Color(0xFF4FD1FF).withValues(alpha: 0.5),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.028;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-22 * math.pi / 180);

    final orbitRect = Rect.fromCenter(
      center: Offset.zero,
      width: w * 0.85,
      height: h * 0.35,
    );

    // Draw dashed orbit
    final path = Path()..addOval(orbitRect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      final dashLength = w * 0.06;
      final gapLength = w * 0.04;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extractPath, orbitPaint);
        distance += dashLength + gapLength;
      }
    }
    canvas.restore();

    // Orbit satellite nodes
    final satPaint1 = Paint()..color = const Color(0xFF7C6CFF);
    final satPaint2 = Paint()..color = const Color(0xFF4FD1FF);
    canvas.drawCircle(Offset(w * 0.16, h * 0.38), w * 0.03, satPaint1);
    canvas.drawCircle(Offset(w * 0.84, h * 0.62), w * 0.03, satPaint2);

    // 2. Structural "N" Strokes
    final x1 = cx - w * 0.24;
    final x2 = cx + w * 0.24;
    final y1 = cy - h * 0.26;
    final y2 = cy + h * 0.26;

    final nPath = Path()
      ..moveTo(x1, y2)
      ..lineTo(x1, y1)
      ..lineTo(x2, y2)
      ..lineTo(x2, y1);

    final strokePaint = Paint()
      ..shader = mainShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(nPath, strokePaint);

    // 3. Outer Endpoint Structural Nodes with Embedded Module Icons
    final bgNodeFill = Paint()..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
    final nodeRadius = w * 0.085;
    final iconSize = w * 0.095;

    // Top-Left Node (Academics & Study)
    _drawNodeCircle(canvas, Offset(x1, y1), nodeRadius, bgNodeFill, const Color(0xFF7C6CFF), w * 0.03);
    _drawNodeIcon(canvas, Offset(x1, y1), Icons.auto_stories_rounded, iconSize, const Color(0xFF7C6CFF));

    // Bottom-Left Node (Finance)
    _drawNodeCircle(canvas, Offset(x1, y2), nodeRadius, bgNodeFill, const Color(0xFF4FD1FF), w * 0.03);
    _drawNodeIcon(canvas, Offset(x1, y2), Icons.account_balance_wallet_rounded, iconSize, const Color(0xFF4FD1FF));

    // Top-Right Node (Career)
    _drawNodeCircle(canvas, Offset(x2, y1), nodeRadius, bgNodeFill, const Color(0xFFF59E0B), w * 0.03);
    _drawNodeIcon(canvas, Offset(x2, y1), Icons.work_outline_rounded, iconSize, const Color(0xFFF59E0B));

    // Bottom-Right Node (Personal Growth)
    _drawNodeCircle(canvas, Offset(x2, y2), nodeRadius, bgNodeFill, const Color(0xFFEC4899), w * 0.03);
    _drawNodeIcon(canvas, Offset(x2, y2), Icons.trending_up_rounded, iconSize, const Color(0xFFEC4899));

    // 4. Central Core Node Aura & Inner Core (AI Hub)
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4FD1FF).withValues(alpha: 0.7),
          const Color(0xFF7C6CFF).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: w * 0.22));

    canvas.drawCircle(Offset(cx, cy), w * 0.18, glowPaint);

    _drawNodeCircle(canvas, Offset(cx, cy), w * 0.095, bgNodeFill, const Color(0xFF4F8CFF), w * 0.035);
    _drawNodeIcon(canvas, Offset(cx, cy), Icons.hub_rounded, iconSize * 1.1, const Color(0xFF4F8CFF));
  }

  void _drawNodeCircle(Canvas canvas, Offset center, double radius, Paint bgFill, Color strokeColor, double strokeWidth) {
    canvas.drawCircle(center, radius, bgFill);
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, strokePaint);
  }

  void _drawNodeIcon(Canvas canvas, Offset center, IconData iconData, double iconSize, Color color) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: color,
        ),
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _NexusMarkPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

/// Clean Nexus Ecosystem Logo Component (Integrated N Mark with node icons + wordmark).
class NexusEcosystemLogoMark extends StatelessWidget {
  final double size;
  final bool isDark;
  final bool showWordmark;

  const NexusEcosystemLogoMark({
    super.key,
    this.size = 120.0,
    this.isDark = true,
    this.showWordmark = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? const Color(0xFFF5F7FA) : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NexusLogoMark(
            size: size,
            isDark: isDark,
          ),
          if (showWordmark) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NEXUS ',
                  style: GoogleFonts.poppins(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: 1.0,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF7C6CFF), Color(0xFF4F8CFF), Color(0xFF4FD1FF)],
                  ).createShader(bounds),
                  child: Text(
                    'AI',
                    style: GoogleFonts.poppins(
                      fontSize: size * 0.22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'CONNECTED LIFE INTELLIGENCE',
              style: GoogleFonts.poppins(
                fontSize: size * 0.085,
                fontWeight: FontWeight.w600,
                color: subtextColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
