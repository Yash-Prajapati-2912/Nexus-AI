import 'package:equatable/equatable.dart';

class AccessibilityEntity extends Equatable {
  final bool largeTextEnabled;
  final bool highContrastEnabled;
  final bool reduceMotionEnabled;
  final bool screenReaderOptimized;
  final double touchTargetScale;

  const AccessibilityEntity({
    required this.largeTextEnabled,
    required this.highContrastEnabled,
    required this.reduceMotionEnabled,
    required this.screenReaderOptimized,
    required this.touchTargetScale,
  });

  factory AccessibilityEntity.initial() {
    return const AccessibilityEntity(
      largeTextEnabled: false,
      highContrastEnabled: false,
      reduceMotionEnabled: false,
      screenReaderOptimized: false,
      touchTargetScale: 1.0,
    );
  }

  AccessibilityEntity copyWith({
    bool? largeTextEnabled,
    bool? highContrastEnabled,
    bool? reduceMotionEnabled,
    bool? screenReaderOptimized,
    double? touchTargetScale,
  }) {
    return AccessibilityEntity(
      largeTextEnabled: largeTextEnabled ?? this.largeTextEnabled,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      reduceMotionEnabled: reduceMotionEnabled ?? this.reduceMotionEnabled,
      screenReaderOptimized: screenReaderOptimized ?? this.screenReaderOptimized,
      touchTargetScale: touchTargetScale ?? this.touchTargetScale,
    );
  }

  @override
  List<Object?> get props => [
        largeTextEnabled,
        highContrastEnabled,
        reduceMotionEnabled,
        screenReaderOptimized,
        touchTargetScale,
      ];
}
