import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDisplay(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String formatFull(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  static String monthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 1);

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}