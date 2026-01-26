import 'package:wanigo_nasabah/core/utils/date_formatter.dart';

class CalendarScheduleModel {
  final int day;
  final String month;
  final String weekday;
  final String message;

  CalendarScheduleModel({
    required this.day,
    required this.month,
    required this.weekday,
    required this.message,
  });

  factory CalendarScheduleModel.today({String? message}) {
    final now = DateTime.now();
    return CalendarScheduleModel(
      day: now.day,
      month: DateFormatter.formatAbbreviatedMonth(now),
      weekday: DateFormatter.formatFullWeekday(now),
      message:
          message ?? 'Jadwal Pemilahan/Penyetoran Sampah Anda Belum Dibuat.',
    );
  }
}
