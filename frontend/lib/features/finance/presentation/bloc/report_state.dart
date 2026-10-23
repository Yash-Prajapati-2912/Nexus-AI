import 'package:equatable/equatable.dart';
import '../../domain/entities/financial_report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitialState extends ReportState {
  const ReportInitialState();
}

class ReportLoadingState extends ReportState {
  const ReportLoadingState();
}

class ReportFailureState extends ReportState {
  final String message;

  const ReportFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReportLoadedState extends ReportState {
  final FinancialReport report;

  const ReportLoadedState({required this.report});

  @override
  List<Object?> get props => [report];
}
