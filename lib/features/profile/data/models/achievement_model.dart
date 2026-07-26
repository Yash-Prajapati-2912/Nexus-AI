import '../../domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.badgeUrl,
    required super.category,
    super.isUnlocked,
    super.unlockedAt,
    required super.progress,
    required super.maxProgress,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Achievement',
      description: json['description'] as String? ?? '',
      badgeUrl: json['badgeUrl'] as String? ?? json['icon'] as String? ?? '',
      category: json['category'] as String? ?? 'ACADEMIC',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt'] as String) : null,
      progress: json['progress'] as int? ?? 0,
      maxProgress: json['maxProgress'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'badgeUrl': badgeUrl,
      'category': category,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
      'maxProgress': maxProgress,
    };
  }
}
