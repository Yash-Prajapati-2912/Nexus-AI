import 'dart:math';
import 'package:flutter/material.dart';

class RadialBudgetWidget extends StatefulWidget {
  final double plannedAmount;
  final double currentSpent;
  final String currencySymbol;

  const RadialBudgetWidget({
    super.key,
    required this.plannedAmount,
    required this.currentSpent,
    this.currencySymbol = '₹',
  });

  @override
  State<RadialBudgetWidget> createState() => _RadialBudgetWidgetState();
}

class _RadialBudgetWidgetState extends State<RadialBudgetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final targetPercentage = (widget.plannedAmount > 0)
        ? (widget.currentSpent / widget.plannedAmount).clamp(0.0, 1.2)
        : 0.0;

    _progressAnimation = Tween<double>(begin: 0.0, end: targetPercentage).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant RadialBudgetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plannedAmount != widget.plannedAmount ||
        oldWidget.currentSpent != widget.currentSpent) {
      final targetPercentage = (widget.plannedAmount > 0)
          ? (widget.currentSpent / widget.plannedAmount).clamp(0.0, 1.2)
          : 0.0;
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: targetPercentage,
      ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getStateColor(double pct) {
    if (pct >= 1.0) return Colors.redAccent;
    if (pct >= 0.9) return Colors.deepOrangeAccent;
    if (pct >= 0.75) return Colors.amber;
    return const Color(0xFF10B981); // Emerald green
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (widget.plannedAmount - widget.currentSpent);
    final pct = (widget.plannedAmount > 0)
        ? (widget.currentSpent / widget.plannedAmount)
        : 0.0;
    final stateColor = _getStateColor(pct);

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 180),
                painter: _RadialPainter(
                  progress: _progressAnimation.value,
                  color: stateColor,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(pct * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: stateColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    remaining >= 0
                        ? '${widget.currencySymbol}${remaining.toStringAsFixed(0)}'
                        : '-${widget.currencySymbol}${remaining.abs().toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    remaining >= 0 ? 'remaining' : 'over budget',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: remaining >= 0
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RadialPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track arc (270 degrees)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = 135 * (pi / 180);
    const totalAngle = 270 * (pi / 180);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalAngle,
      false,
      bgPaint,
    );

    // Active progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (progress.clamp(0.0, 1.0)) * totalAngle;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
