import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/usecases/generate_report_usecase.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GenerateReportUseCase generateReportUseCase;

  ReportBloc({required this.generateReportUseCase}) : super(const ReportInitialState()) {
    on<LoadReportEvent>(_onLoadReport);
  }

  Future<void> _onLoadReport(
    LoadReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoadingState());
    final result = await generateReportUseCase(event.timeframe);

    result.fold(
      (Failure f) => emit(ReportFailureState(message: f.message)),
      (report) => emit(ReportLoadedState(report: report)),
    );
  }
}
