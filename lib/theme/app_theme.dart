import 'package:flutter/material.dart';
import 'design_tokens/colors.dart';
import 'design_tokens/typography.dart';
import 'theme_extensions.dart';

/// Material 3 ThemeData builder for Light and Dark modes.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: DesignColors.primaryLight,
        onPrimary: DesignColors.onPrimaryLight,
        primaryContainer: DesignColors.primaryContainerLight,
        secondary: DesignColors.secondaryLight,
        surface: DesignColors.surfaceLight,
        error: DesignColors.errorLight,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundLight,
      fontFamily: DesignTypography.fontFamily,
      extensions: const [AiThemeExtension.light],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: DesignColors.primaryDark,
        onPrimary: DesignColors.onPrimaryDark,
        primaryContainer: DesignColors.primaryContainerDark,
        secondary: DesignColors.secondaryDark,
        surface: DesignColors.surfaceDark,
        error: DesignColors.errorDark,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundDark,
      fontFamily: DesignTypography.fontFamily,
      extensions: const [AiThemeExtension.dark],
    );
  }
}
