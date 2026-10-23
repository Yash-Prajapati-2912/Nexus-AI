import 'dart:math';
import 'package:flutter/material.dart';


class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (sin((_controller.value * 2 * pi) - delay) + 1) / 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              height: 8 + (value * 6),
              width: 8 + (value * 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha((100 + (value * 155)).toInt()),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
