import 'package:flutter/material.dart';

class AppGhostButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const AppGhostButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: child,
      ),
    );
  }
}
