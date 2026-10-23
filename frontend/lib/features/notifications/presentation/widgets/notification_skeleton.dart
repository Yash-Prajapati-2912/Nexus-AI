import 'package:flutter/material.dart';

class NotificationSkeleton extends StatefulWidget {
  final double height;

  const NotificationSkeleton({super.key, this.height = 80});

  @override
  State<NotificationSkeleton> createState() => _NotificationSkeletonState();
}

class _NotificationSkeletonState extends State<NotificationSkeleton>
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
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withAlpha((_animation.value * 255).toInt()),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
