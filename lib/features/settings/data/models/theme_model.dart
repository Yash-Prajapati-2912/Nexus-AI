import '../../domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  const ThemeModel({
    required super.themeMode,
    required super.useDynamicColor,
    required super.primaryColorHex,
    required super.isMaterial3,
    required super.fontScale,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    AppThemeMode mode = AppThemeMode.system;
    final modeStr = json['theme'] as String? ?? json['themeMode'] as String? ?? 'SYSTEM';
    if (modeStr.toUpperCase() == 'LIGHT') mode = AppThemeMode.light;
    if (modeStr.toUpperCase() == 'DARK') mode = AppThemeMode.dark;

    return ThemeModel(
      themeMode: mode,
      useDynamicColor: json['useDynamicColor'] as bool? ?? true,
      primaryColorHex: json['primaryColorHex'] as String? ?? '0xFF6750A4',
      isMaterial3: json['isMaterial3'] as bool? ?? true,
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': themeMode.name.toUpperCase(),
      'useDynamicColor': useDynamicColor,
      'primaryColorHex': primaryColorHex,
      'isMaterial3': isMaterial3,
      'fontScale': fontScale,
    };
  }

  factory ThemeModel.fromEntity(ThemeEntity entity) {
    return ThemeModel(
      themeMode: entity.themeMode,
      useDynamicColor: entity.useDynamicColor,
      primaryColorHex: entity.primaryColorHex,
      isMaterial3: entity.isMaterial3,
      fontScale: entity.fontScale,
    );
  }
}
