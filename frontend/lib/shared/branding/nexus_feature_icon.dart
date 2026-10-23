import 'package:flutter/material.dart';

enum NexusFeatureModule {
  /// 1. PLAN / ACADEMICS - calendar / checklist / study concept
  academics,

  /// 2. FINANCE - wallet / financial chart / budget concept
  finance,

  /// 3. CAREER - briefcase / career path / guidance concept
  career,

  /// 4. PERSONAL GROWTH - person / progress / wellness concept
  personalGrowth,

  /// 5. AI / NEXUS - central Nexus node/core concept
  aiNexus,
}

/// Cohesive, Branded Feature Icon system for Nexus AI modules.
class NexusFeatureIcon extends StatelessWidget {
  final NexusFeatureModule module;
  final double size;
  final Color? color;
  final bool showContainer;
  final Color? containerColor;

  const NexusFeatureIcon({
    super.key,
    required this.module,
    this.size = 24.0,
    this.color,
    this.showContainer = false,
    this.containerColor,
  });

  IconData get _iconData {
    switch (module) {
      case NexusFeatureModule.academics:
        return Icons.auto_stories_rounded; // Academic study & planner concept
      case NexusFeatureModule.finance:
        return Icons.account_balance_wallet_rounded; // Finance & wallet concept
      case NexusFeatureModule.career:
        return Icons.work_outline_rounded; // Career briefcase concept
      case NexusFeatureModule.personalGrowth:
        return Icons.trending_up_rounded; // Personal growth & progress concept
      case NexusFeatureModule.aiNexus:
        return Icons.hub_rounded; // Central Nexus node/core concept
    }
  }

  LinearGradient get _accentGradient {
    switch (module) {
      case NexusFeatureModule.academics:
        return const LinearGradient(
          colors: [Color(0xFF7C6CFF), Color(0xFF4F8CFF)],
        );
      case NexusFeatureModule.finance:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF4FD1FF)],
        );
      case NexusFeatureModule.career:
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFF7C6CFF)],
        );
      case NexusFeatureModule.personalGrowth:
        return const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF4F8CFF)],
        );
      case NexusFeatureModule.aiNexus:
        return const LinearGradient(
          colors: [Color(0xFF7C6CFF), Color(0xFF4F8CFF), Color(0xFF4FD1FF)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ?? (isDark ? const Color(0xFFF5F7FA) : const Color(0xFF0F172A));

    Widget iconWidget = ShaderMask(
      shaderCallback: (bounds) => _accentGradient.createShader(bounds),
      child: Icon(
        _iconData,
        size: size,
        color: defaultColor,
      ),
    );

    if (!showContainer) return iconWidget;

    final defaultContainerColor = containerColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9));

    return Container(
      width: size * 1.8,
      height: size * 1.8,
      decoration: BoxDecoration(
        color: defaultContainerColor,
        borderRadius: BorderRadius.circular(size * 0.4),
        border: Border.all(
          color: (color ?? const Color(0xFF7C6CFF)).withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Center(child: iconWidget),
    );
  }
}
