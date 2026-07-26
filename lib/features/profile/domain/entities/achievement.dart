import 'package:equatable/equatable.dart';

/// Domain entity representing gamification badges & achievements.
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String badgeUrl;
  final String category; // ACADEMIC, PRODUCTIVITY, FINANCE, AI_MENTOR, STREAK
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int progress;
  final int maxProgress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeUrl,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.progress,
    required this.maxProgress,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        badgeUrl,
        category,
        isUnlocked,
        unlockedAt,
        progress,
        maxProgress,
      ];
}
