import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark, system }

class ThemeEntity extends Equatable {
  final AppThemeMode themeMode;
  final bool useDynamicColor;
  final String primaryColorHex;
  final bool isMaterial3;
  final double fontScale;

  const ThemeEntity({
    required this.themeMode,
    required this.useDynamicColor,
    required this.primaryColorHex,
    required this.isMaterial3,
    required this.fontScale,
  });

  factory ThemeEntity.initial() {
    return const ThemeEntity(
      themeMode: AppThemeMode.system,
      useDynamicColor: true,
      primaryColorHex: '0xFF6750A4',
      isMaterial3: true,
      fontScale: 1.0,
    );
  }

  ThemeEntity copyWith({
    AppThemeMode? themeMode,
    bool? useDynamicColor,
    String? primaryColorHex,
    bool? isMaterial3,
    double? fontScale,
  }) {
    return ThemeEntity(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      isMaterial3: isMaterial3 ?? this.isMaterial3,
      fontScale: fontScale ?? this.fontScale,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        useDynamicColor,
        primaryColorHex,
        isMaterial3,
        fontScale,
      ];
}
