import '../../domain/entities/milestone_entity.dart';

class MilestoneModel {
  final String id;
  final String title;
  final bool isCompleted;

  const MilestoneModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  MilestoneEntity toDomain() => MilestoneEntity(id: id, title: title, isCompleted: isCompleted);
}
