import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/exceptions.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/features/finance/data/datasources/finance_remote_data_source.dart';
import 'package:nexus_ai/features/finance/data/models/budget_model.dart';
import 'package:nexus_ai/features/finance/data/models/expense_model.dart';
import 'package:nexus_ai/features/finance/data/models/finance_category_model.dart';
import 'package:nexus_ai/features/finance/data/models/income_model.dart';
import 'package:nexus_ai/features/finance/data/models/savings_goal_model.dart';
import 'package:nexus_ai/features/finance/domain/entities/budget.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/finance_category.dart';
import 'package:nexus_ai/features/finance/domain/entities/financial_report.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/domain/entities/savings_goal.dart';
import 'package:nexus_ai/features/finance/domain/entities/transaction.dart';
import 'package:nexus_ai/features/finance/domain/repositories/i_finance_repository.dart';


class FinanceRepositoryImpl implements IFinanceRepository {
  final IFinanceRemoteDataSource remoteDataSource;

  FinanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Expense>>> getExpenses({
    String? categoryId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getExpenses(
        categoryId: categoryId,
        startDate: startDate,
        endDate: endDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        search: search,
      );
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Expense>> createExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final created = await remoteDataSource.createExpense(model);
      return Right(created);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final updated = await remoteDataSource.updateExpense(model);
      return Right(updated);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpense(String id) async {
    try {
      await remoteDataSource.deleteExpense(id);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Income>>> getIncomes({String? sourceCategory, String? startDate, String? endDate}) async {
    try {
      final models = await remoteDataSource.getIncomes(
        sourceCategory: sourceCategory,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Income>> createIncome(Income income) async {
    try {
      final model = IncomeModel.fromEntity(income);
      final created = await remoteDataSource.createIncome(model);
      return Right(created);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Income>> updateIncome(Income income) async {
    try {
      final model = IncomeModel.fromEntity(income);
      final updated = await remoteDataSource.updateIncome(model);
      return Right(updated);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteIncome(String id) async {
    try {
      await remoteDataSource.deleteIncome(id);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final models = await remoteDataSource.getBudgets();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);
      final created = await remoteDataSource.createBudget(model);
      return Right(created);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);
      final updated = await remoteDataSource.updateBudget(model);
      return Right(updated);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals() async {
    try {
      final models = await remoteDataSource.getSavingsGoals();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> createSavingsGoal(SavingsGoal goal) async {
    try {
      final model = SavingsGoalModel.fromEntity(goal);
      final created = await remoteDataSource.createSavingsGoal(model);
      return Right(created);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final model = SavingsGoalModel.fromEntity(goal);
      final updated = await remoteDataSource.updateSavingsGoal(model);
      return Right(updated);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> addContribution(String goalId, double amount, String? note) async {
    try {
      final updated = await remoteDataSource.addContribution(goalId, amount, note);
      return Right(updated);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSavingsGoal(String id) async {
    try {
      await remoteDataSource.deleteSavingsGoal(id);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<FinanceCategory>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FinanceCategory>> createCategory(FinanceCategory category) async {
    try {
      final model = FinanceCategoryModel.fromEntity(category);
      final created = await remoteDataSource.createCategory(model);
      return Right(created);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({String? query, String? type}) async {
    try {
      final models = await remoteDataSource.getTransactions(query: query, type: type);
      return Right(models);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FinancialReport>> getFinancialReport(String timeframe) async {
    try {
      final model = await remoteDataSource.getFinancialReport(timeframe);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object e) {
    if (e is ValidationException) {
      return ValidationFailure(message: e.message, fieldErrors: e.errors);
    } else if (e is UnauthorizedException) {
      return const UnauthorizedFailure();
    } else if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else {
      return UnknownFailure(message: e.toString());
    }
  }
}
