import 'package:flutter/material.dart';

extension MediaQueryX on BuildContext {
  bool get isCompact => MediaQuery.of(this).size.width < 600;
  bool get isMedium =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 840;
  bool get isExpanded => MediaQuery.of(this).size.width >= 840;
}
