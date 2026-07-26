import '../../domain/entities/accessibility_entity.dart';

class AccessibilityModel extends AccessibilityEntity {
  const AccessibilityModel({
    required super.largeTextEnabled,
    required super.highContrastEnabled,
    required super.reduceMotionEnabled,
    required super.screenReaderOptimized,
    required super.touchTargetScale,
  });

  factory AccessibilityModel.fromJson(Map<String, dynamic> json) {
    return AccessibilityModel(
      largeTextEnabled: json['largeTextEnabled'] as bool? ?? false,
      highContrastEnabled: json['highContrastEnabled'] as bool? ?? false,
      reduceMotionEnabled: json['reduceMotionEnabled'] as bool? ?? false,
      screenReaderOptimized: json['screenReaderOptimized'] as bool? ?? false,
      touchTargetScale: (json['touchTargetScale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'largeTextEnabled': largeTextEnabled,
      'highContrastEnabled': highContrastEnabled,
      'reduceMotionEnabled': reduceMotionEnabled,
      'screenReaderOptimized': screenReaderOptimized,
      'touchTargetScale': touchTargetScale,
    };
  }

  factory AccessibilityModel.fromEntity(AccessibilityEntity entity) {
    return AccessibilityModel(
      largeTextEnabled: entity.largeTextEnabled,
      highContrastEnabled: entity.highContrastEnabled,
      reduceMotionEnabled: entity.reduceMotionEnabled,
      screenReaderOptimized: entity.screenReaderOptimized,
      touchTargetScale: entity.touchTargetScale,
    );
  }
}
