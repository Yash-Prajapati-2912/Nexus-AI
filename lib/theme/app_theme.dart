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
        secondary: DesignColors.secondaryLight,
        surface: DesignColors.surfaceLight,
        onSurface: DesignColors.textPrimaryLight,
        onSurfaceVariant: DesignColors.textSecondaryLight,
        error: DesignColors.errorLight,
        outlineVariant: DesignColors.glassBorderLight,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundLight,
      fontFamily: DesignTypography.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryLight),
        bodyMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryLight),
        bodySmall: GoogleFonts.poppins(color: DesignColors.textSecondaryLight),
        labelSmall: GoogleFonts.poppins(color: DesignColors.textSecondaryLight),
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
          fontWeight: FontWeight.bold,
          color: DesignColors.textPrimaryLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primaryLight,
          foregroundColor: DesignColors.onPrimaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.lg),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.primaryLight,
          side: const BorderSide(color: DesignColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.lg),
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
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.lg),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: DesignColors.textPrimaryLight,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DesignColors.glassSurfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.xl,
          side: BorderSide(color: DesignColors.glassBorderLight, width: 1.2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceLight,
        elevation: 12,
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.xl,
          side: BorderSide(color: DesignColors.glassBorderLight, width: 1.2),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: DesignColors.textPrimaryLight,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DesignColors.surfaceLight,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignColors.glassSurfaceLight,
        selectedColor: DesignColors.primaryLight.withOpacity(0.15),
        secondarySelectedColor: DesignColors.primaryLight,
        disabledColor: Colors.grey.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
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
        fillColor: DesignColors.glassSurfaceLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.glassBorderLight, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.glassBorderLight, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.primaryLight, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.errorLight, width: 1.2),
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
        secondary: DesignColors.secondaryDark,
        surface: DesignColors.surfaceDark,
        onSurface: DesignColors.textPrimaryDark,
        onSurfaceVariant: DesignColors.textSecondaryDark,
        error: DesignColors.errorDark,
        outlineVariant: DesignColors.glassBorderDark,
      ),
      scaffoldBackgroundColor: DesignColors.backgroundDark,
      fontFamily: DesignTypography.fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: DesignColors.textPrimaryDark),
        bodyMedium: GoogleFonts.poppins(color: DesignColors.textPrimaryDark),
        bodySmall: GoogleFonts.poppins(color: DesignColors.textSecondaryDark),
        labelSmall: GoogleFonts.poppins(color: DesignColors.textSecondaryDark),
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
          fontWeight: FontWeight.bold,
          color: DesignColors.textPrimaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.primaryDark,
          foregroundColor: DesignColors.onPrimaryDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.lg),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignColors.primaryDark,
          side: const BorderSide(color: DesignColors.primaryDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: DesignRadius.lg),
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
        shape: RoundedRectangleBorder(borderRadius: DesignRadius.lg),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: DesignColors.textPrimaryDark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DesignColors.glassSurfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: DesignRadius.xl,
          side: BorderSide(color: DesignColors.glassBorderDark, width: 1.2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: DesignColors.surfaceDark,
        elevation: 12,
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.xl,
          side: BorderSide(color: DesignColors.glassBorderDark, width: 1.2),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: DesignColors.textPrimaryDark,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DesignColors.surfaceDark,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignColors.glassSurfaceDark,
        selectedColor: DesignColors.primaryDark.withOpacity(0.2),
        secondarySelectedColor: DesignColors.primaryDark,
        disabledColor: Colors.grey.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: DesignRadius.lg,
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
        fillColor: DesignColors.glassSurfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.glassBorderDark, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.glassBorderDark, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.primaryDark, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: DesignRadius.lg,
          borderSide: BorderSide(color: DesignColors.errorDark, width: 1.2),
        ),
      ),
      extensions: const [AiThemeExtension.dark],
    );
  }
}
