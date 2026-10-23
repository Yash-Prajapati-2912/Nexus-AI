import 'package:equatable/equatable.dart';

class PlannerFilterEntity extends Equatable {
  final String? priority;
  final String? status;
  final String? category;
  final String? searchQuery;

  const PlannerFilterEntity({
    this.priority,
    this.status,
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [priority, status, category, searchQuery];
}
