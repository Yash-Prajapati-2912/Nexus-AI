import 'package:intl/intl.dart';

/// Date formatting and manipulation utilities.
abstract class AppDateUtils {
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
