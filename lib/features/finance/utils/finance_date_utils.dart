import '../domain/entities/expense.dart';
import '../domain/entities/income.dart';

/// A bucket of financial data for a specific date period.
class FinanceDateBucket {
  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpense;
  final double net;

  const FinanceDateBucket({
    required this.label,
    required this.startDate,
    required this.endDate,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.net = 0.0,
  });
}

/// Centralized Date/Time utilities and period groupers for the Finance module.
abstract class FinanceDateUtils {
  /// Start of the local calendar day: 00:00:00.000.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
  }

  /// End of the local calendar day: 23:59:59.999.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }

  /// Start of the week: Monday 00:00:00.000.
  /// Correctly handles weeks crossing month and year boundaries.
  static DateTime startOfWeek(DateTime date) {
    final diffToMonday = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day - diffToMonday, 0, 0, 0, 0, 0);
  }

  /// End of the week: Sunday 23:59:59.999.
  static DateTime endOfWeek(DateTime date) {
    final monday = startOfWeek(date);
    return DateTime(monday.year, monday.month, monday.day + 6, 23, 59, 59, 999, 999);
  }

  /// Start of the calendar month: 1st of month at 00:00:00.000.
  static DateTime startOfMonth(int year, int month) {
    return DateTime(year, month, 1, 0, 0, 0, 0, 0);
  }

  /// End of the calendar month: last day at 23:59:59.999.
  /// Accurately handles 28-day Feb, leap years (29 days), 30-day and 31-day months.
  static DateTime endOfMonth(int year, int month) {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999, 999);
  }

  /// Start of the calendar year: January 1 at 00:00:00.000.
  static DateTime startOfYear(int year) {
    return DateTime(year, 1, 1, 0, 0, 0, 0, 0);
  }

  /// End of the calendar year: December 31 at 23:59:59.999.
  static DateTime endOfYear(int year) {
    return DateTime(year, 12, 31, 23, 59, 59, 999, 999);
  }

  /// Checks if a date falls strictly within [start, end] inclusive.
  static bool isInRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  /// Formats date to 'YYYY-MM-DD' key for reliable day comparisons.
  static String formatKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Groups expenses and incomes into a continuous daily timeline.
  /// Preserves empty days with 0.0 amounts.
  /// Sorted chronologically (oldest -> newest).
  static List<FinanceDateBucket> groupDaily({
    required DateTime startDate,
    required DateTime endDate,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) {
    final sDay = startOfDay(startDate);
    final eDay = startOfDay(endDate);

    final List<FinanceDateBucket> buckets = [];
    DateTime curr = sDay;

    while (!curr.isAfter(eDay)) {
      final bucketStart = startOfDay(curr);
      final bucketEnd = endOfDay(curr);

      final dayExpenses = expenses.where((e) => isInRange(e.date, bucketStart, bucketEnd));
      final dayIncomes = incomes.where((i) => isInRange(i.date, bucketStart, bucketEnd));

      final expTotal = dayExpenses.fold(0.0, (sum, e) => sum + e.amount);
      final incTotal = dayIncomes.fold(0.0, (sum, i) => sum + i.amount);

      buckets.add(FinanceDateBucket(
        label: formatKey(curr),
        startDate: bucketStart,
        endDate: bucketEnd,
        totalIncome: incTotal,
        totalExpense: expTotal,
        net: incTotal - expTotal,
      ));

      curr = curr.add(const Duration(days: 1));
      // Guard for daylight saving time jump
      if (curr.hour != 0) {
        curr = DateTime(curr.year, curr.month, curr.day, 0, 0, 0);
      }
    }

    buckets.sort((a, b) => a.startDate.compareTo(b.startDate));
    return buckets;
  }

  /// Groups expenses and incomes into continuous Monday -> Sunday weekly buckets.
  /// Preserves empty weeks with 0.0 amounts.
  /// Sorted chronologically (oldest -> newest).
  static List<FinanceDateBucket> groupWeekly({
    required DateTime startDate,
    required DateTime endDate,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) {
    DateTime curr = startOfWeek(startDate);
    final finalEnd = endOfWeek(endDate);

    final List<FinanceDateBucket> buckets = [];

    while (!curr.isAfter(finalEnd)) {
      final wStart = startOfWeek(curr);
      final wEnd = endOfWeek(curr);

      final wExpenses = expenses.where((e) => isInRange(e.date, wStart, wEnd));
      final wIncomes = incomes.where((i) => isInRange(i.date, wStart, wEnd));

      final expTotal = wExpenses.fold(0.0, (sum, e) => sum + e.amount);
      final incTotal = wIncomes.fold(0.0, (sum, i) => sum + i.amount);

      final label = '${formatKey(wStart)} to ${formatKey(wEnd)}';

      buckets.add(FinanceDateBucket(
        label: label,
        startDate: wStart,
        endDate: wEnd,
        totalIncome: incTotal,
        totalExpense: expTotal,
        net: incTotal - expTotal,
      ));

      curr = DateTime(wStart.year, wStart.month, wStart.day + 7, 0, 0, 0);
    }

    buckets.sort((a, b) => a.startDate.compareTo(b.startDate));
    return buckets;
  }

  /// Groups expenses and incomes into 12 calendar monthly buckets for the given year.
  /// Preserves empty months with 0.0 amounts.
  /// Sorted chronologically (Jan -> Dec).
  static List<FinanceDateBucket> groupMonthly({
    required int year,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final List<FinanceDateBucket> buckets = [];

    for (int m = 1; m <= 12; m++) {
      final mStart = startOfMonth(year, m);
      final mEnd = endOfMonth(year, m);

      final mExpenses = expenses.where((e) => isInRange(e.date, mStart, mEnd));
      final mIncomes = incomes.where((i) => isInRange(i.date, mStart, mEnd));

      final expTotal = mExpenses.fold(0.0, (sum, e) => sum + e.amount);
      final incTotal = mIncomes.fold(0.0, (sum, i) => sum + i.amount);

      buckets.add(FinanceDateBucket(
        label: '${monthNames[m - 1]} $year',
        startDate: mStart,
        endDate: mEnd,
        totalIncome: incTotal,
        totalExpense: expTotal,
        net: incTotal - expTotal,
      ));
    }

    buckets.sort((a, b) => a.startDate.compareTo(b.startDate));
    return buckets;
  }

  /// Groups expenses and incomes into continuous calendar yearly buckets.
  /// Preserves empty years with 0.0 amounts.
  /// Sorted chronologically (oldest -> newest).
  static List<FinanceDateBucket> groupYearly({
    required int startYear,
    required int endYear,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) {
    final List<FinanceDateBucket> buckets = [];

    for (int y = startYear; y <= endYear; y++) {
      final yStart = startOfYear(y);
      final yEnd = endOfYear(y);

      final yExpenses = expenses.where((e) => isInRange(e.date, yStart, yEnd));
      final yIncomes = incomes.where((i) => isInRange(i.date, yStart, yEnd));

      final expTotal = yExpenses.fold(0.0, (sum, e) => sum + e.amount);
      final incTotal = yIncomes.fold(0.0, (sum, i) => sum + i.amount);

      buckets.add(FinanceDateBucket(
        label: '$y',
        startDate: yStart,
        endDate: yEnd,
        totalIncome: incTotal,
        totalExpense: expTotal,
        net: incTotal - expTotal,
      ));
    }

    buckets.sort((a, b) => a.startDate.compareTo(b.startDate));
    return buckets;
  }
}
