import 'package:flutter/material.dart';

/// Animation Durations & Curves Tokens.
abstract class DesignAnimationTokens {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standardCurve = Curves.easeInOut;
  static const Curve decelerateCurve = Curves.easeOutCubic;
  static const Curve accelerateCurve = Curves.easeInCubic;
  static const Curve bounceCurve = Curves.elasticOut;
}
