import '../../domain/entities/goal_entity.dart';
import 'milestone_model.dart';

class GoalModel {
  final String id;
  final String title;
  final String description;
  final double progressPercentage;
  final List<MilestoneModel> milestones;

  const GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.progressPercentage,
    required this.milestones,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    final list = (json['milestones'] as List<dynamic>?)
            ?.map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return GoalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      milestones: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'progressPercentage': progressPercentage,
        'milestones': milestones.map((e) => e.toJson()).toList(),
      };

  GoalEntity toDomain() {
    return GoalEntity(
      id: id,
      title: title,
      description: description,
      progressPercentage: progressPercentage,
      milestones: milestones.map((e) => e.toDomain()).toList(),
    );
  }
}
