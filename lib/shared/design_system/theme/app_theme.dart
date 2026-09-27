import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tokens/colors/app_colors.dart';
import '../tokens/colors/semantic_colors.dart';
import '../tokens/typography/app_typography.dart';
import 'component_themes/bottom_sheet_theme.dart';
import 'component_themes/button_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/dialog_theme.dart';
import 'component_themes/input_theme.dart';
import 'component_themes/snackbar_theme.dart';
import 'theme_extensions.dart';

abstract class DesignAppTheme {
  static ThemeData get lightTheme {
    const colors = ColorScheme(
      brightness: Brightness.light,
      primary: DesignAppColors.primaryLight,
      onPrimary: DesignAppColors.onPrimaryLight,
      primaryContainer: DesignAppColors.primaryContainerLight,
      onPrimaryContainer: DesignAppColors.onPrimaryContainerLight,
      secondary: DesignAppColors.secondaryLight,
      onSecondary: DesignAppColors.onSecondaryLight,
      secondaryContainer: DesignAppColors.secondaryContainerLight,
      onSecondaryContainer: DesignAppColors.secondaryLight,
      tertiary: DesignAppColors.tertiaryLight,
      onTertiary: DesignAppColors.onTertiaryLight,
      tertiaryContainer: DesignAppColors.tertiaryLight,
      onTertiaryContainer: DesignAppColors.onTertiaryLight,
      error: SemanticColors.error,
      onError: SemanticColors.onError,
      errorContainer: SemanticColors.errorContainer,
      onErrorContainer: SemanticColors.error,
      surface: DesignAppColors.surfaceLight,
      onSurface: DesignAppColors.textPrimaryLight,
      surfaceContainerHighest: DesignAppColors.surfaceVariantLight,
      onSurfaceVariant: DesignAppColors.textSecondaryLight,
      outline: DesignAppColors.outlineLight,
      outlineVariant: DesignAppColors.outlineVariantLight,
    );

    final baseTextTheme = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: DesignAppColors.backgroundLight,
      fontFamily: DesignTypographyTokens.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme),
      filledButtonTheme: AppButtonTheme.filledButtonTheme(colors),
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme(colors),
      inputDecorationTheme: AppInputTheme.inputDecorationTheme(colors),
      cardTheme: AppCardTheme.cardTheme(colors),
      dialogTheme: AppDialogTheme.dialogTheme(colors),
      bottomSheetTheme: AppBottomSheetTheme.bottomSheetTheme(colors),
      snackBarTheme: AppSnackBarTheme.snackBarTheme(colors),
      extensions: const [
        DesignAiThemeExtension(
          aiAccent: SemanticColors.aiAccent,
          aiGradient: SemanticColors.aiGradient,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    const colors = ColorScheme(
      brightness: Brightness.dark,
      primary: DesignAppColors.primaryDark,
      onPrimary: DesignAppColors.onPrimaryDark,
      primaryContainer: DesignAppColors.primaryContainerDark,
      onPrimaryContainer: DesignAppColors.onPrimaryContainerDark,
      secondary: DesignAppColors.secondaryDark,
      onSecondary: DesignAppColors.onSecondaryDark,
      secondaryContainer: DesignAppColors.secondaryDark,
      onSecondaryContainer: DesignAppColors.onSecondaryDark,
      tertiary: DesignAppColors.tertiaryDark,
      onTertiary: DesignAppColors.onTertiaryDark,
      tertiaryContainer: DesignAppColors.tertiaryDark,
      onTertiaryContainer: DesignAppColors.onTertiaryDark,
      error: SemanticColors.error,
      onError: SemanticColors.onError,
      errorContainer: SemanticColors.errorContainer,
      onErrorContainer: SemanticColors.error,
      surface: DesignAppColors.surfaceDark,
      onSurface: DesignAppColors.textPrimaryDark,
      surfaceContainerHighest: DesignAppColors.surfaceVariantDark,
      onSurfaceVariant: DesignAppColors.textSecondaryDark,
      outline: DesignAppColors.outlineDark,
      outlineVariant: DesignAppColors.outlineVariantDark,
    );

    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: DesignAppColors.backgroundDark,
      fontFamily: DesignTypographyTokens.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme),
      filledButtonTheme: AppButtonTheme.filledButtonTheme(colors),
      outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme(colors),
      inputDecorationTheme: AppInputTheme.inputDecorationTheme(colors),
      cardTheme: AppCardTheme.cardTheme(colors),
      dialogTheme: AppDialogTheme.dialogTheme(colors),
      bottomSheetTheme: AppBottomSheetTheme.bottomSheetTheme(colors),
      snackBarTheme: AppSnackBarTheme.snackBarTheme(colors),
      extensions: const [
        DesignAiThemeExtension(
          aiAccent: SemanticColors.aiAccent,
          aiGradient: SemanticColors.aiGradient,
        ),
      ],
    );
  }
}

