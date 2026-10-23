import 'package:equatable/equatable.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/entities/language_entity.dart';
import '../../domain/entities/accessibility_entity.dart';

class ThemeState extends Equatable {
  final ThemeEntity theme;
  final LanguageEntity language;
  final AccessibilityEntity accessibility;
  final bool isLoading;

  const ThemeState({
    required this.theme,
    required this.language,
    required this.accessibility,
    this.isLoading = false,
  });

  factory ThemeState.initial() {
    return ThemeState(
      theme: ThemeEntity.initial(),
      language: LanguageEntity.initial(),
      accessibility: AccessibilityEntity.initial(),
    );
  }

  ThemeState copyWith({
    ThemeEntity? theme,
    LanguageEntity? language,
    AccessibilityEntity? accessibility,
    bool? isLoading,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      accessibility: accessibility ?? this.accessibility,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [theme, language, accessibility, isLoading];
}
