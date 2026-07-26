import 'package:equatable/equatable.dart';
import '../../domain/entities/income.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadIncomeEvent extends IncomeEvent {
  final String? sourceCategory;
  final String? startDate;
  final String? endDate;

  const LoadIncomeEvent({this.sourceCategory, this.startDate, this.endDate});

  @override
  List<Object?> get props => [sourceCategory, startDate, endDate];
}

class CreateIncomeEvent extends IncomeEvent {
  final Income income;

  const CreateIncomeEvent(this.income);

  @override
  List<Object?> get props => [income];
}

class DeleteIncomeEvent extends IncomeEvent {
  final String id;

  const DeleteIncomeEvent(this.id);

  @override
  List<Object?> get props => [id];
}
