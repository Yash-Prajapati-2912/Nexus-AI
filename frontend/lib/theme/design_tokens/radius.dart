import 'package:flutter/material.dart';

/// Design Token Border Radius scale (2026 Sleek & Controlled Radius System).
abstract class DesignRadius {
  static const double smValue = 8.0;
  static const double mdValue = 12.0;
  static const double lgValue = 16.0;
  static const double xlValue = 20.0;
  static const double xxlValue = 28.0;
  static const double fullValue = 999.0;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(xxlValue));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));
}


