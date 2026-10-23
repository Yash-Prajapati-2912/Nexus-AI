import 'package:flutter/material.dart';

class AIMentorSkeleton extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const AIMentorSkeleton({
    super.key,
    this.height = 80,
    this.width = double.infinity,
    this.borderRadius = 16,
  });

  @override
  State<AIMentorSkeleton> createState() => _AIMentorSkeletonState();
}

class _AIMentorSkeletonState extends State<AIMentorSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: baseColor.withAlpha((_animation.value * 255).toInt()),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
