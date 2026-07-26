import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

extension ThemeContextExtension on BuildContext {
  AiThemeExtension get aiTheme =>
      Theme.of(this).extension<AiThemeExtension>() ?? AiThemeExtension.light;
}
