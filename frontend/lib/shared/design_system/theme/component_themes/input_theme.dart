import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

abstract class AppInputTheme {
  static InputDecorationTheme inputDecorationTheme(ColorScheme colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: DesignRadiusTokens.md,
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: DesignRadiusTokens.md,
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: DesignRadiusTokens.md,
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: DesignRadiusTokens.md,
        borderSide: BorderSide(color: colors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
