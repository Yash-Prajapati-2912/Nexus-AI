import 'package:equatable/equatable.dart';
import 'milestone_entity.dart';

class GoalEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double progressPercentage;
  final List<MilestoneEntity> milestones;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.progressPercentage,
    required this.milestones,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        progressPercentage,
        milestones,
      ];
}
