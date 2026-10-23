import 'package:flutter/material.dart';

/// 2026 Design Token Colors for Dual-Theme AI Operating System (Light & Dark).
abstract class DesignColors {
  // Light Palette
  static const Color primaryLight = Color(0xFF4F46E5); // Indigo 600
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFEEF2FF); // Indigo 50
  static const Color onPrimaryContainerLight = Color(0xFF1E1B4B); // Indigo 950

  static const Color secondaryLight = Color(0xFF0284C7); // Sky 600 (Cyan/Blue secondary)
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFE0F2FE);

  static const Color accentPurpleLight = Color(0xFF7C3AED); // Violet
  static const Color accentCyanLight = Color(0xFF0284C7); // Cyan/Sky

  // Financial States
  static const Color positiveGreenLight = Color(0xFF10B981); // Emerald 500
  static const Color negativeRedLight = Color(0xFFEF4444); // Red 500

  // Light Surfaces Hierarchy
  static const Color backgroundLight = Color(0xFFF8FAFC); // App Background (Slate 50)
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF); // Elevated Surface
  static const Color surfaceLight = Color(0xFFFFFFFF); // Card Surface
  static const Color surfaceSelectedLight = Color(0xFFEEF2FF); // Selected/Interactive Surface
  static const Color surfaceInputLight = Color(0xFFF1F5F9); // Input Fill Surface

  static const Color glassSurfaceLight = Color(0xFFFFFFFF);
  static const Color glassBorderLight = Color(0xFFE2E8F0); // Subtle Slate Border
  static const Color errorLight = Color(0xFFEF4444);
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600
  static const Color textMutedLight = Color(0xFF94A3B8); // Slate 400

  // Dark Palette (2026 Deep Near-Black Dark Mode)
  static const Color primaryDark = Color(0xFF6366F1); // Indigo 500
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color primaryContainerDark = Color(0xFF1E1B4B); // Indigo 950
  static const Color onPrimaryContainerDark = Color(0xFFE0E7FF);

  static const Color secondaryDark = Color(0xFF06B6D4); // Cyan 500
  static const Color onSecondaryDark = Color(0xFF00363A);
  static const Color secondaryContainerDark = Color(0xFF004D40);

  static const Color accentPurpleDark = Color(0xFF8B5CF6);
  static const Color accentCyanDark = Color(0xFF06B6D4);

  // Financial States (Dark)
  static const Color positiveGreenDark = Color(0xFF10B981);
  static const Color negativeRedDark = Color(0xFFEF4444);

  // Dark Surfaces Hierarchy (Controlled Contrast, Deep Near-Black)
  static const Color backgroundDark = Color(0xFF080B11); // 1. Deep Near-Black App Background
  static const Color surfaceElevatedDark = Color(0xFF0E131F); // 2. Elevated Surface
  static const Color surfaceDark = Color(0xFF141B2A); // 3. Card Surface
  static const Color surfaceSelectedDark = Color(0xFF1D263B); // 4. Interactive/Selected Surface
  static const Color surfaceInputDark = Color(0xFF111623); // 5. Input Surface

  static const Color glassSurfaceDark = Color(0xCC141B2A);
  static const Color glassBorderDark = Color(0x26FFFFFF); // Subtle Controlled Contrast Border
  static const Color errorDark = Color(0xFFF87171);
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textMutedDark = Color(0xFF64748B); // Slate 500

  // Gradients - Dark
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cyanVioletGradientDark = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients - Light
  static const LinearGradient primaryGradientLight = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cyanVioletGradientLight = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle Mesh Ambient Glow Colors (Toned down, elegant)
  static const Color meshPurpleDark = Color(0x1F7C3AED);
  static const Color meshCyanDark = Color(0x1406B6D4);
  static const Color meshPurpleLight = Color(0x0E8B5CF6);
  static const Color meshCyanLight = Color(0x0A0284C7);
}


