import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/usecases/create_income_usecase.dart';
import '../../domain/usecases/get_income_usecase.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';

import 'income_event.dart';
import 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final GetIncomeUseCase getIncomeUseCase;
  final CreateIncomeUseCase createIncomeUseCase;
  final IFinanceRepository repository;

  IncomeBloc({
    required this.getIncomeUseCase,
    required this.createIncomeUseCase,
    required this.repository,
  }) : super(const IncomeInitialState()) {
    on<LoadIncomeEvent>(_onLoadIncome);
    on<CreateIncomeEvent>(_onCreateIncome);
    on<DeleteIncomeEvent>(_onDeleteIncome);
  }

  Future<void> _onLoadIncome(
    LoadIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(const IncomeLoadingState());
    final result = await getIncomeUseCase(GetIncomeParams(
      sourceCategory: event.sourceCategory,
      startDate: event.startDate,
      endDate: event.endDate,
    ));

    result.fold(
      (Failure f) => emit(IncomeFailureState(message: f.message)),
      (incomes) => emit(IncomeLoadedState(incomes: incomes)),
    );
  }

  Future<void> _onCreateIncome(
    CreateIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(const IncomeLoadingState());
    final result = await createIncomeUseCase(event.income);

    result.fold(
      (Failure f) => emit(IncomeFailureState(message: f.message)),
      (income) => emit(const IncomeOperationSuccessState(message: 'Income added successfully.')),
    );
  }

  Future<void> _onDeleteIncome(
    DeleteIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(const IncomeLoadingState());
    final result = await repository.deleteIncome(event.id);

    result.fold(
      (Failure f) => emit(IncomeFailureState(message: f.message)),
      (_) => emit(const IncomeOperationSuccessState(message: 'Income deleted successfully.')),
    );
  }
}
