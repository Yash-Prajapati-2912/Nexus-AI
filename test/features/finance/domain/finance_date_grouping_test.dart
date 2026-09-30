import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/finance/domain/entities/expense.dart';
import 'package:nexus_ai/features/finance/domain/entities/income.dart';
import 'package:nexus_ai/features/finance/utils/finance_date_utils.dart';

void main() {
  group('FinanceDateUtils - Boundaries and Conversions', () {
    test('Daily boundaries: 00:00:00.000 to 23:59:59.999', () {
      final sample = DateTime(2026, 9, 30, 15, 45, 22);
      final start = FinanceDateUtils.startOfDay(sample);
      final end = FinanceDateUtils.endOfDay(sample);

      expect(start, DateTime(2026, 9, 30, 0, 0, 0, 0, 0));
      expect(end, DateTime(2026, 9, 30, 23, 59, 59, 999, 999));
    });

    test('Transaction at 23:30 local does not roll into next day', () {
      final lateNightTx = DateTime(2026, 9, 30, 23, 30, 0);
      final key = FinanceDateUtils.formatKey(lateNightTx);
      expect(key, '2026-09-30');

      final sept30Start = FinanceDateUtils.startOfDay(DateTime(2026, 9, 30));
      final sept30End = FinanceDateUtils.endOfDay(DateTime(2026, 9, 30));
      final oct1Start = FinanceDateUtils.startOfDay(DateTime(2026, 10, 1));
      final oct1End = FinanceDateUtils.endOfDay(DateTime(2026, 10, 1));

      expect(FinanceDateUtils.isInRange(lateNightTx, sept30Start, sept30End), isTrue);
      expect(FinanceDateUtils.isInRange(lateNightTx, oct1Start, oct1End), isFalse);
    });

    test('Transaction at exactly 00:00 is placed on the current day', () {
      final midnightTx = DateTime(2026, 10, 1, 0, 0, 0);
      final oct1Start = FinanceDateUtils.startOfDay(DateTime(2026, 10, 1));
      final oct1End = FinanceDateUtils.endOfDay(DateTime(2026, 10, 1));
      final sept30Start = FinanceDateUtils.startOfDay(DateTime(2026, 9, 30));
      final sept30End = FinanceDateUtils.endOfDay(DateTime(2026, 9, 30));

      expect(FinanceDateUtils.isInRange(midnightTx, oct1Start, oct1End), isTrue);
      expect(FinanceDateUtils.isInRange(midnightTx, sept30Start, sept30End), isFalse);
    });

    test('Transaction at exactly 23:59:59 is included in the current day', () {
      final endOfDayTx = DateTime(2026, 9, 30, 23, 59, 59);
      final sept30Start = FinanceDateUtils.startOfDay(DateTime(2026, 9, 30));
      final sept30End = FinanceDateUtils.endOfDay(DateTime(2026, 9, 30));

      expect(FinanceDateUtils.isInRange(endOfDayTx, sept30Start, sept30End), isTrue);
    });

    test('Weekly grouping: Monday -> Sunday convention', () {
      // 2026-09-30 is Wednesday
      final wednesday = DateTime(2026, 9, 30, 14, 0);
      final monday = FinanceDateUtils.startOfWeek(wednesday);
      final sunday = FinanceDateUtils.endOfWeek(wednesday);

      expect(monday.weekday, DateTime.monday);
      expect(monday, DateTime(2026, 9, 28, 0, 0, 0));

      expect(sunday.weekday, DateTime.sunday);
      expect(sunday.year, 2026);
      expect(sunday.month, 10);
      expect(sunday.day, 4);
      expect(sunday.hour, 23);
      expect(sunday.minute, 59);
    });

    test('Week crossing year boundary (e.g. 2026-12-31 to 2027-01-03)', () {
      // 2026-12-31 is Thursday
      final thursday = DateTime(2026, 12, 31, 23, 0);
      final monday = FinanceDateUtils.startOfWeek(thursday);
      final sunday = FinanceDateUtils.endOfWeek(thursday);

      expect(monday, DateTime(2026, 12, 28, 0, 0, 0));
      expect(sunday.year, 2027);
      expect(sunday.month, 1);
      expect(sunday.day, 3);
      expect(sunday.hour, 23);
      expect(sunday.minute, 59);
    });

    test('Monthly grouping: 28-day February vs leap year 29-day February', () {
      // 2026 is non-leap year (28 days)
      final feb2026End = FinanceDateUtils.endOfMonth(2026, 2);
      expect(feb2026End.day, 28);
      expect(feb2026End.month, 2);

      // 2024 is leap year (29 days)
      final feb2024End = FinanceDateUtils.endOfMonth(2024, 2);
      expect(feb2024End.day, 29);
      expect(feb2024End.month, 2);
    });

    test('Monthly grouping: 30-day and 31-day months', () {
      final sepEnd = FinanceDateUtils.endOfMonth(2026, 9);
      expect(sepEnd.day, 30);

      final octEnd = FinanceDateUtils.endOfMonth(2026, 10);
      expect(octEnd.day, 31);
    });

    test('Yearly grouping: Jan 1 to Dec 31', () {
      final start = FinanceDateUtils.startOfYear(2026);
      final end = FinanceDateUtils.endOfYear(2026);

      expect(start, DateTime(2026, 1, 1, 0, 0, 0));
      expect(end, DateTime(2026, 12, 31, 23, 59, 59, 999, 999));
    });
  });

  group('FinanceDateUtils - Continuous Timeline and Empty Period Preservation', () {
    final e1 = Expense(
      id: 'e1',
      title: 'Groceries',
      amount: 150.0,
      categoryId: 'food',
      categoryName: 'Food',
      categoryIcon: 'restaurant',
      date: DateTime(2026, 9, 28, 10, 0),
    );

    final e2 = Expense(
      id: 'e2',
      title: 'Dinner',
      amount: 50.0,
      categoryId: 'food',
      categoryName: 'Food',
      categoryIcon: 'restaurant',
      date: DateTime(2026, 9, 30, 21, 0),
    );

    final i1 = Income(
      id: 'i1',
      title: 'Salary',
      amount: 1000.0,
      sourceCategory: 'Job',
      date: DateTime(2026, 9, 28, 9, 0),
    );

    test('groupDaily: preserves empty day (Sept 29) with 0.0 and sorts chronologically', () {
      final buckets = FinanceDateUtils.groupDaily(
        startDate: DateTime(2026, 9, 28),
        endDate: DateTime(2026, 9, 30),
        expenses: [e2, e1], // deliberately unsorted
        incomes: [i1],
      );

      expect(buckets.length, 3);
      // Chronological order
      expect(buckets[0].label, '2026-09-28');
      expect(buckets[0].totalExpense, 150.0);
      expect(buckets[0].totalIncome, 1000.0);
      expect(buckets[0].net, 850.0);

      // Sept 29 is empty
      expect(buckets[1].label, '2026-09-29');
      expect(buckets[1].totalExpense, 0.0);
      expect(buckets[1].totalIncome, 0.0);
      expect(buckets[1].net, 0.0);

      expect(buckets[2].label, '2026-09-30');
      expect(buckets[2].totalExpense, 50.0);
      expect(buckets[2].totalIncome, 0.0);
      expect(buckets[2].net, -50.0);
    });

    test('groupWeekly: preserves empty weeks with 0.0 and sorts chronologically', () {
      final buckets = FinanceDateUtils.groupWeekly(
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 9, 30),
        expenses: [e1],
        incomes: [i1],
      );

      // September 2026 spans 5 weeks (Aug 31-Sep 6, Sep 7-13, Sep 14-20, Sep 21-27, Sep 28-Oct 4)
      expect(buckets.length, 5);
      // All weeks except the last one have 0 expense
      expect(buckets[0].totalExpense, 0.0);
      expect(buckets[1].totalExpense, 0.0);
      expect(buckets[2].totalExpense, 0.0);
      expect(buckets[3].totalExpense, 0.0);
      expect(buckets[4].totalExpense, 150.0);
      // Verified chronological
      for (int i = 0; i < buckets.length - 1; i++) {
        expect(buckets[i].startDate.isBefore(buckets[i + 1].startDate), isTrue);
      }
    });

    test('groupMonthly: preserves all 12 months with 0.0 and sorts Jan -> Dec', () {
      final buckets = FinanceDateUtils.groupMonthly(
        year: 2026,
        expenses: [e1, e2],
        incomes: [i1],
      );

      expect(buckets.length, 12);
      expect(buckets[0].label, 'Jan 2026');
      expect(buckets[0].totalExpense, 0.0);
      expect(buckets[0].totalIncome, 0.0);

      expect(buckets[8].label, 'Sep 2026');
      expect(buckets[8].totalExpense, 200.0);
      expect(buckets[8].totalIncome, 1000.0);
      expect(buckets[8].net, 800.0);

      expect(buckets[11].label, 'Dec 2026');
      expect(buckets[11].totalExpense, 0.0);
      expect(buckets[11].totalIncome, 0.0);
    });

    test('groupYearly: preserves years with 0.0 and sorts chronologically', () {
      final buckets = FinanceDateUtils.groupYearly(
        startYear: 2024,
        endYear: 2026,
        expenses: [e1, e2],
        incomes: [i1],
      );

      expect(buckets.length, 3);
      expect(buckets[0].label, '2024');
      expect(buckets[0].totalExpense, 0.0);

      expect(buckets[1].label, '2025');
      expect(buckets[1].totalExpense, 0.0);

      expect(buckets[2].label, '2026');
      expect(buckets[2].totalExpense, 200.0);
      expect(buckets[2].totalIncome, 1000.0);
    });
  });
}
