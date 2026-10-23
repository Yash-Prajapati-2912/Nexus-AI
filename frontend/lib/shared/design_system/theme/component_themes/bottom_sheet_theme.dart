import 'package:flutter/material.dart';

abstract class AppBottomSheetTheme {
  static BottomSheetThemeData bottomSheetTheme(ColorScheme colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}
