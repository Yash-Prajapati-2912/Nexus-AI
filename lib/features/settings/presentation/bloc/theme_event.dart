import 'package:equatable/equatable.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/entities/accessibility_entity.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadThemePreferencesEvent extends ThemeEvent {
  const LoadThemePreferencesEvent();
}

class ChangeThemeModeEvent extends ThemeEvent {
  final AppThemeMode mode;
  const ChangeThemeModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ToggleDynamicColorEvent extends ThemeEvent {
  final bool useDynamic;
  const ToggleDynamicColorEvent(this.useDynamic);

  @override
  List<Object?> get props => [useDynamic];
}

class ChangePrimaryColorEvent extends ThemeEvent {
  final String hexColor;
  const ChangePrimaryColorEvent(this.hexColor);

  @override
  List<Object?> get props => [hexColor];
}

class UpdateLanguageSettingsEvent extends ThemeEvent {
  final LanguageEntity language;
  const UpdateLanguageSettingsEvent(this.language);

  @override
  List<Object?> get props => [language];
}

class UpdateAccessibilitySettingsEvent extends ThemeEvent {
  final AccessibilityEntity accessibility;
  const UpdateAccessibilitySettingsEvent(this.accessibility);

  @override
  List<Object?> get props => [accessibility];
}
