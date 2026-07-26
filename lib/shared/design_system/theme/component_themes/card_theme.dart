import 'package:flutter/material.dart';
import '../../tokens/radius/app_radius.dart';

abstract class AppCardTheme {
  static CardThemeData cardTheme(ColorScheme colors) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: DesignRadiusTokens.lg,
        side: BorderSide(color: colors.outlineVariant, width: 1),
      ),
      color: colors.surface,
    );
  }
}
