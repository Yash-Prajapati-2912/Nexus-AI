import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../entities/income.dart';
import '../repositories/i_finance_repository.dart';

class GetIncomeParams extends Equatable {
  final String? sourceCategory;
  final String? startDate;
  final String? endDate;

  const GetIncomeParams({this.sourceCategory, this.startDate, this.endDate});

  @override
  List<Object?> get props => [sourceCategory, startDate, endDate];
}

class GetIncomeUseCase implements UseCase<List<Income>, GetIncomeParams> {
  final IFinanceRepository repository;

  GetIncomeUseCase(this.repository);

  @override
  Future<Either<Failure, List<Income>>> call(GetIncomeParams params) {
    return repository.getIncomes(
      sourceCategory: params.sourceCategory,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
