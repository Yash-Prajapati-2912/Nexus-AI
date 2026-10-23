import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

abstract class AppButtonTheme {
  static FilledButtonThemeData filledButtonTheme(ColorScheme colors) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(borderRadius: DesignRadiusTokens.md),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(borderRadius: DesignRadiusTokens.md),
        side: BorderSide(color: colors.outline),
        foregroundColor: colors.primary,
      ),
    );
  }
}
