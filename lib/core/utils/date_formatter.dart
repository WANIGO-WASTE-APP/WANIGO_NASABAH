import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'id').format(date);
  }

  static String formatAbbreviatedMonth(DateTime date) {
    return DateFormat('MMM', 'id').format(date);
  }

  static String formatFullWeekday(DateTime date) {
    return DateFormat('EEEE', 'id').format(date);
  }

  static String formatApiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
