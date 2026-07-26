import 'package:flutter/material.dart';
import 'design_tokens/colors.dart';

/// Custom Theme Extension for AI-specific accent gradients and styling.
class AiThemeExtension extends ThemeExtension<AiThemeExtension> {
  final Color aiAccentColor;
  final LinearGradient aiGradient;

  const AiThemeExtension({
    required this.aiAccentColor,
    required this.aiGradient,
  });

  static const light = AiThemeExtension(
    aiAccentColor: DesignColors.accentPurpleLight,
    aiGradient: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const dark = AiThemeExtension(
    aiAccentColor: DesignColors.accentPurpleDark,
    aiGradient: LinearGradient(
      colors: [Color(0xFFA78BFA), Color(0xFF818CF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  @override
  ThemeExtension<AiThemeExtension> copyWith({
    Color? aiAccentColor,
    LinearGradient? aiGradient,
  }) {
    return AiThemeExtension(
      aiAccentColor: aiAccentColor ?? this.aiAccentColor,
      aiGradient: aiGradient ?? this.aiGradient,
    );
  }

  @override
  ThemeExtension<AiThemeExtension> lerp(
    covariant ThemeExtension<AiThemeExtension>? other,
    double t,
  ) {
    if (other is! AiThemeExtension) return this;
    return AiThemeExtension(
      aiAccentColor: Color.lerp(aiAccentColor, other.aiAccentColor, t)!,
      aiGradient: LinearGradient.lerp(aiGradient, other.aiGradient, t)!,
    );
  }
}
