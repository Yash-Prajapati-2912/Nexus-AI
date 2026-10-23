/// Represents the budget health status according to established thresholds.
enum BudgetHealthStatus {
  noBudget,
  underBudget,
  approachingBudget,
  overBudget,
}

/// Structured result containing all Budget Health calculations.
class BudgetHealthResult {
  final double monthlyBudget;
  final double spent;
  final double remaining;
  final double usagePercentage;
  final int totalDaysInMonth;
  final int elapsedDays;
  final int remainingDays;
  final double normalDailyBudget;
  final double? averageDailySpending;
  final double? projectedMonthEnd;
  final double safeDailyLimit;
  final BudgetHealthStatus status;

  const BudgetHealthResult({
    required this.monthlyBudget,
    required this.spent,
    required this.remaining,
    required this.usagePercentage,
    required this.totalDaysInMonth,
    required this.elapsedDays,
    required this.remainingDays,
    required this.normalDailyBudget,
    this.averageDailySpending,
    this.projectedMonthEnd,
    required this.safeDailyLimit,
    required this.status,
  });

  bool get isOverBudget => status == BudgetHealthStatus.overBudget;
  bool get isApproachingBudget => status == BudgetHealthStatus.approachingBudget;
  bool get isUnderBudget => status == BudgetHealthStatus.underBudget;
}

/// Canonical Budget Health Calculator.
///
/// Separates the Normal Daily Budget (Monthly Budget / Total Days in Month)
/// from the Safe Daily Limit (Remaining Budget / Remaining Days in Month)
/// and calculates Projected Month-End Spending safely.
class BudgetHealthCalculator {
  static BudgetHealthResult calculate({
    required double monthlyBudget,
    required double currentSpent,
    DateTime? currentDate,
    int? daysInMonth,
    int? elapsedDays,
    int? remainingDays,
  }) {
    final now = currentDate ?? DateTime.now();
    final totalDays = daysInMonth ?? DateTime(now.year, now.month + 1, 0).day;
    final elapsed = elapsedDays ?? now.day.clamp(1, totalDays);

    // Remaining days calculation:
    // If not provided: on the final day (or past it), exactly 1 day remains for spending.
    // Otherwise, days remaining in the month is (totalDays - elapsed).
    final remaining = remainingDays ?? (totalDays - elapsed <= 0 ? 1 : totalDays - elapsed);

    // Remaining budget = Monthly Budget - Spent
    final remainingBudget = monthlyBudget - currentSpent;

    // Usage percentage = (Spent / Monthly Budget) * 100
    // Safe zero handling prevents division by zero
    final usagePct = (monthlyBudget > 0)
        ? (currentSpent / monthlyBudget) * 100.0
        : 0.0;

    // Normal Daily Budget = Monthly Budget / Total Days In Month
    final normalDaily = (monthlyBudget > 0 && totalDays > 0)
        ? monthlyBudget / totalDays
        : 0.0;

    // Safe Daily Limit = Remaining Budget / Remaining Days
    // If remaining budget <= 0, safe daily limit is 0.0
    final safeDaily = (remainingBudget > 0 && remaining > 0)
        ? remainingBudget / remaining
        : 0.0;

    // Projected Month-End:
    // Average Daily Spending = Spent So Far / Elapsed Days
    // Projected Month-End Spending = Average Daily Spending * Total Days In Month
    // Handled safely: Only calculated when spending and elapsed days exist (do not invent for zero spending).
    double? avgDaily;
    double? projected;
    if (currentSpent > 0 && elapsed > 0) {
      avgDaily = currentSpent / elapsed;
      projected = avgDaily * totalDays;
    }

    // Thresholds:
    // > 100% -> overBudget
    // >= 80% -> approachingBudget
    // < 80%  -> underBudget
    final BudgetHealthStatus status;
    if (monthlyBudget <= 0) {
      status = BudgetHealthStatus.noBudget;
    } else if (usagePct > 100.0) {
      status = BudgetHealthStatus.overBudget;
    } else if (usagePct >= 80.0) {
      status = BudgetHealthStatus.approachingBudget;
    } else {
      status = BudgetHealthStatus.underBudget;
    }

    return BudgetHealthResult(
      monthlyBudget: monthlyBudget,
      spent: currentSpent,
      remaining: remainingBudget,
      usagePercentage: usagePct,
      totalDaysInMonth: totalDays,
      elapsedDays: elapsed,
      remainingDays: remaining,
      normalDailyBudget: normalDaily,
      averageDailySpending: avgDaily,
      projectedMonthEnd: projected,
      safeDailyLimit: safeDaily,
      status: status,
    );
  }
}
