import 'package:flutter/material.dart';

/// Theme extension providing AI custom colors and gradients.
class DesignAiThemeExtension extends ThemeExtension<DesignAiThemeExtension> {
  final Color aiAccent;
  final LinearGradient aiGradient;

  const DesignAiThemeExtension({
    required this.aiAccent,
    required this.aiGradient,
  });

  @override
  DesignAiThemeExtension copyWith({
    Color? aiAccent,
    LinearGradient? aiGradient,
  }) {
    return DesignAiThemeExtension(
      aiAccent: aiAccent ?? this.aiAccent,
      aiGradient: aiGradient ?? this.aiGradient,
    );
  }

  @override
  DesignAiThemeExtension lerp(
    ThemeExtension<DesignAiThemeExtension>? other,
    double t,
  ) {
    if (other is! DesignAiThemeExtension) return this;
    return DesignAiThemeExtension(
      aiAccent: Color.lerp(aiAccent, other.aiAccent, t)!,
      aiGradient: LinearGradient.lerp(aiGradient, other.aiGradient, t)!,
    );
  }
}
