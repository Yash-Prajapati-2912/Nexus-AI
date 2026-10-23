import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

abstract class AppSnackBarTheme {
  static SnackBarThemeData snackBarTheme(ColorScheme colors) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: DesignRadiusTokens.md),
      backgroundColor: colors.inverseSurface,
      contentTextStyle: TextStyle(color: colors.onInverseSurface),
    );
  }
}
