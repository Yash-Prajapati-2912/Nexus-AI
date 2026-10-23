import 'package:equatable/equatable.dart';

class MilestoneEntity extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const MilestoneEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, title, isCompleted];
}
