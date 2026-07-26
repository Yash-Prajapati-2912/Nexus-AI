import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

abstract class AppDialogTheme {
  static DialogThemeData dialogTheme(ColorScheme colors) {
    return DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: DesignRadiusTokens.lg),
      backgroundColor: colors.surface,
    );
  }
}
