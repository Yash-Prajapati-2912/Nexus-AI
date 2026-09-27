import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens/colors.dart';
import 'design_tokens/radius.dart';
import 'design_tokens/typography.dart';
import 'theme_extensions.dart';

/// 2026 Material 3 ThemeData builder for Pristine Light Mode and Futuristic Dark Mode.
abstract class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: DesignColors.primaryLight,
        onPrimary: DesignColors.onPrimaryLight,
        primaryContainer: DesignColors.primaryContainerLight,
        onPrimaryContainer: DesignColors.onPrimaryContainerLight,
        secondary: DesignColors.secondaryLight,
        onSecondary: DesignColors.onSecondaryLight,
        secondaryContainer: DesignColors.secondaryContainerLight,
        surface: DesignColors.surfaceLight,
        onSurface: DesignColors.textPrimaryLight,
        onSurfaceVariant: DesignColors.textSecondaryLight,
        error: DesignColors.errorLight,
        outlineVariant: DesignColors.glassBorderLight,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundLight,
      fontFamily: DesignTypography.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displayMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displaySmall: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        headlineLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        headlineMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.poppins(color: DesignColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: GoogleFonts.poppins(color: DesignColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(color: DesignColors.textSecondaryLight, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.4),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: DesignColors.textPrimaryLight),
        actionsIconTheme: const IconThemeData(color: DesignColors.textPrimaryLight),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DesignColors.textPrimaryLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primaryLight,
          foregroundColor: DesignColors.onPrimaryLight,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.primaryLight,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: DesignColors.primaryLight, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignColors.primaryLight,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignColors.primaryLight,
        foregroundColor: DesignColors.onPrimaryLight,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.md),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: DesignColors.textPrimaryLight,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DesignColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
          side: BorderSide(color: DesignColors.glassBorderLight, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceElevatedLight,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
          side: BorderSide(color: DesignColors.glassBorderLight, width: 1.0),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DesignColors.textPrimaryLight,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DesignColors.surfaceElevatedLight,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignColors.surfaceInputLight,
        selectedColor: DesignColors.primaryLight.withValues(alpha: 0.15),
        secondarySelectedColor: DesignColors.primaryLight,
        disabledColor: Colors.grey.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.md,
          side: BorderSide(color: DesignColors.glassBorderLight, width: 1),
        ),
        labelStyle: GoogleFonts.poppins(
          color: DesignColors.textPrimaryLight,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignColors.glassBorderLight,
        thickness: 1,
        space: 16,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: DesignColors.textSecondaryLight,
        textColor: DesignColors.textPrimaryLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DesignColors.surfaceInputLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.glassBorderLight, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.glassBorderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.primaryLight, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.errorLight, width: 1.0),
        ),
      ),
      extensions: const [AiThemeExtension.light],
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: DesignColors.primaryDark,
        onPrimary: DesignColors.onPrimaryDark,
        primaryContainer: DesignColors.primaryContainerDark,
        onPrimaryContainer: DesignColors.onPrimaryContainerDark,
        secondary: DesignColors.secondaryDark,
        onSecondary: DesignColors.onSecondaryDark,
        secondaryContainer: DesignColors.secondaryContainerDark,
        surface: DesignColors.surfaceDark,
        onSurface: DesignColors.textPrimaryDark,
        onSurfaceVariant: DesignColors.textSecondaryDark,
        error: DesignColors.errorDark,
        outlineVariant: DesignColors.glassBorderDark,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundDark,
      fontFamily: DesignTypography.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displayMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displaySmall: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        headlineLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3),
        headlineMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.poppins(color: DesignColors.textSecondaryDark, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: GoogleFonts.poppins(color: DesignColors.textSecondaryDark, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.poppins(color: DesignColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.4),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: DesignColors.textPrimaryDark),
        actionsIconTheme: const IconThemeData(color: DesignColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DesignColors.textPrimaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primaryDark,
          foregroundColor: DesignColors.onPrimaryDark,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.primaryDark,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: DesignColors.primaryDark, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.md),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignColors.primaryDark,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignColors.primaryDark,
        foregroundColor: DesignColors.onPrimaryDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.md),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: DesignColors.textPrimaryDark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DesignColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
          side: BorderSide(color: DesignColors.glassBorderDark, width: 1.0),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceElevatedDark,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
          side: BorderSide(color: DesignColors.glassBorderDark, width: 1.0),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: DesignColors.textPrimaryDark,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DesignColors.surfaceElevatedDark,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignColors.surfaceDark,
        selectedColor: DesignColors.primaryDark.withValues(alpha: 0.2),
        secondarySelectedColor: DesignColors.primaryDark,
        disabledColor: Colors.grey.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.md,
          side: BorderSide(color: DesignColors.glassBorderDark, width: 1),
        ),
        labelStyle: GoogleFonts.poppins(
          color: DesignColors.textPrimaryDark,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignColors.glassBorderDark,
        thickness: 1,
        space: 16,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: DesignColors.textSecondaryDark,
        textColor: DesignColors.textPrimaryDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DesignColors.surfaceInputDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.glassBorderDark, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.glassBorderDark, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.primaryDark, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: DesignRadius.md,
          borderSide: BorderSide(color: DesignColors.errorDark, width: 1.0),
        ),
      ),
      extensions: const [AiThemeExtension.dark],
    );
  }
}

