import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/i_finance_repository.dart';

class GetExpensesParams extends Equatable {
  final String? categoryId;
  final String? startDate;
  final String? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? search;

  const GetExpensesParams({
    this.categoryId,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.search,
  });

  @override
  List<Object?> get props => [categoryId, startDate, endDate, minAmount, maxAmount, search];
}

class GetExpensesUseCase implements UseCase<List<Expense>, GetExpensesParams> {
  final IFinanceRepository repository;

  GetExpensesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesParams params) {
    return repository.getExpenses(
      categoryId: params.categoryId,
      startDate: params.startDate,
      endDate: params.endDate,
      minAmount: params.minAmount,
      maxAmount: params.maxAmount,
      search: params.search,
    );
  }
}
