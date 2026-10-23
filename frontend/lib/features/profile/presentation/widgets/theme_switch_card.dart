import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../theme/design_tokens/colors.dart';
import '../../../settings/domain/entities/theme_entity.dart';
import '../../../settings/presentation/bloc/theme_bloc.dart';
import '../../../settings/presentation/bloc/theme_event.dart';
import '../../../settings/presentation/bloc/theme_state.dart';

/// 2026 Glassmorphic Theme Toggle Switch Card for Light, Dark, and System modes.
class ThemeSwitchCard extends StatelessWidget {
  const ThemeSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    final titleColor = isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight;
    final subtitleColor = isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final currentMode = state.theme.themeMode;

        return GlassCard(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentMode == AppThemeMode.light
                          ? Icons.wb_sunny_rounded
                          : currentMode == AppThemeMode.dark
                              ? Icons.nightlight_round
                              : Icons.brightness_auto_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Theme Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          currentMode == AppThemeMode.light
                              ? 'Active: Pristine Light Mode ☀️'
                              : currentMode == AppThemeMode.dark
                                  ? 'Active: Futuristic Dark Mode 🌙'
                                  : 'Active: Dynamic System Theme 💻',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? DesignColors.glassBorderDark : DesignColors.glassBorderLight,
                  ),
                ),
                child: Row(
                  children: [
                    _buildThemeSegment(
                      context,
                      label: 'Light',
                      icon: Icons.wb_sunny_rounded,
                      mode: AppThemeMode.light,
                      isSelected: currentMode == AppThemeMode.light,
                    ),
                    _buildThemeSegment(
                      context,
                      label: 'Dark',
                      icon: Icons.nightlight_round,
                      mode: AppThemeMode.dark,
                      isSelected: currentMode == AppThemeMode.dark,
                    ),
                    _buildThemeSegment(
                      context,
                      label: 'System',
                      icon: Icons.brightness_auto_rounded,
                      mode: AppThemeMode.system,
                      isSelected: currentMode == AppThemeMode.system,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSegment(
    BuildContext context, {
    required String label,
    required IconData icon,
    required AppThemeMode mode,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark ? DesignColors.primaryGradientDark : DesignColors.primaryGradientLight;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ThemeBloc>().add(ChangeThemeModeEvent(mode));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark ? DesignColors.accentPurpleDark : DesignColors.primaryLight).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
