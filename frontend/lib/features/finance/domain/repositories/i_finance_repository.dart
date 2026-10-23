import 'package:fpdart/fpdart.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../entities/budget.dart';
import '../entities/expense.dart';
import '../entities/finance_category.dart';
import '../entities/financial_report.dart';
import '../entities/income.dart';
import '../entities/investment.dart';
import '../entities/savings_goal.dart';
import '../entities/transaction.dart';

abstract class IFinanceRepository {
  // Expenses
  Future<Either<Failure, List<Expense>>> getExpenses({
    String? categoryId,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    String? search,
  });
  Future<Either<Failure, Expense>> createExpense(Expense expense);
  Future<Either<Failure, Expense>> updateExpense(Expense expense);
  Future<Either<Failure, Unit>> deleteExpense(String id);

  // Incomes
  Future<Either<Failure, List<Income>>> getIncomes({String? sourceCategory, String? startDate, String? endDate});
  Future<Either<Failure, Income>> createIncome(Income income);
  Future<Either<Failure, Income>> updateIncome(Income income);
  Future<Either<Failure, Unit>> deleteIncome(String id);

  // Budgets
  Future<Either<Failure, List<Budget>>> getBudgets();
  Future<Either<Failure, Budget>> createBudget(Budget budget);
  Future<Either<Failure, Budget>> updateBudget(Budget budget);

  // Savings Goals
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals();
  Future<Either<Failure, SavingsGoal>> createSavingsGoal(SavingsGoal goal);
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(SavingsGoal goal);
  Future<Either<Failure, SavingsGoal>> addContribution(String goalId, double amount, String? note);
  Future<Either<Failure, Unit>> deleteSavingsGoal(String id);

  // Investments
  Future<Either<Failure, List<Investment>>> getInvestments();
  Future<Either<Failure, Investment>> createInvestment(Investment investment);
  Future<Either<Failure, Investment>> updateInvestment(Investment investment);
  Future<Either<Failure, Unit>> deleteInvestment(String id);

  // Categories, Transactions & Reports
  Future<Either<Failure, List<FinanceCategory>>> getCategories();
  Future<Either<Failure, FinanceCategory>> createCategory(FinanceCategory category);
  Future<Either<Failure, List<Transaction>>> getTransactions({String? query, String? type});
  Future<Either<Failure, FinancialReport>> getFinancialReport(String timeframe);
}
