import 'package:flutter/material.dart';
import '../../../../shared/widgets/glass_card.dart';

/// 2026 Reusable Authentication Container Card with Glassmorphism.
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28.0),
      child: child,
    );
  }
}

