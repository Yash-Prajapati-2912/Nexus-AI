import 'package:flutter/material.dart';
import '../../../widgets/glass_card.dart';

/// 2026 Glassmorphic App Card wrapper with Dual-Theme support.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

