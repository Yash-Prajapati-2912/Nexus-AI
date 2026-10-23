import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';

extension DesignThemeGetterX on ThemeData {
  DesignAiThemeExtension get aiTheme => extension<DesignAiThemeExtension>()!;
}
