import 'package:equatable/equatable.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinanceDashboardEvent extends FinanceEvent {
  const LoadFinanceDashboardEvent();
}

class RefreshFinanceDashboardEvent extends FinanceEvent {
  const RefreshFinanceDashboardEvent();
}
