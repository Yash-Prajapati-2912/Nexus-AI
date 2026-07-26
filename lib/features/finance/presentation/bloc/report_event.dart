import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadReportEvent extends ReportEvent {
  final String timeframe; // DAILY, WEEKLY, MONTHLY, YEARLY

  const LoadReportEvent({this.timeframe = 'MONTHLY'});

  @override
  List<Object?> get props => [timeframe];
}
