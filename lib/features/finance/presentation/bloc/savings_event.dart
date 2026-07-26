import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavingsGoalsEvent extends SavingsEvent {
  const LoadSavingsGoalsEvent();
}

class CreateSavingsGoalEvent extends SavingsEvent {
  final SavingsGoal goal;

  const CreateSavingsGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

class AddSavingsContributionEvent extends SavingsEvent {
  final String goalId;
  final double amount;
  final String? note;

  const AddSavingsContributionEvent({required this.goalId, required this.amount, this.note});

  @override
  List<Object?> get props => [goalId, amount, note];
}

class DeleteSavingsGoalEvent extends SavingsEvent {
  final String id;

  const DeleteSavingsGoalEvent(this.id);

  @override
  List<Object?> get props => [id];
}
