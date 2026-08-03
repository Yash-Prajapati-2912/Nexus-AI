import 'package:flutter/material.dart';

/// 2026 Design Token Colors for Dual-Theme System (Light & Dark).
abstract class DesignColors {
  // Light Palette
  static const Color primaryLight = Color(0xFF4F46E5);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFEEF2FF);
  static const Color secondaryLight = Color(0xFF10B981);
  static const Color accentPurpleLight = Color(0xFF7C3AED);
  static const Color accentCyanLight = Color(0xFF0284C7);
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color glassSurfaceLight = Color(0xFFFFFFFF);
  static const Color glassBorderLight = Color(0xFFE2E8F0);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);

  // Dark Palette
  static const Color primaryDark = Color(0xFF6366F1);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color primaryContainerDark = Color(0xFF1E1B4B);
  static const Color secondaryDark = Color(0xFF34D399);
  static const Color accentPurpleDark = Color(0xFF8B5CF6);
  static const Color accentCyanDark = Color(0xFF06B6D4);
  static const Color backgroundDark = Color(0xFF0B0F17);
  static const Color surfaceDark = Color(0xFF151C2C);
  static const Color glassSurfaceDark = Color(0x991E293B);
  static const Color glassBorderDark = Color(0x33FFFFFF);
  static const Color errorDark = Color(0xFFF87171);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Gradients - Dark
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cyanVioletGradientDark = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients - Light
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cyanVioletGradientLight = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Mesh Ambient Glow Colors
  static const Color meshPurpleDark = Color(0x307C3AED);
  static const Color meshCyanDark = Color(0x2506B6D4);
  static const Color meshPurpleLight = Color(0x1A8B5CF6);
  static const Color meshCyanLight = Color(0x120284C7);
}

