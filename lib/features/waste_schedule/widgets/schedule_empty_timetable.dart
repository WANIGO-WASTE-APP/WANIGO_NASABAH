import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';

class ScheduleEmptyTimetable extends StatelessWidget {
  const ScheduleEmptyTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      iconPath: 'assets/icons/form_submission_icon.svg',
      title: 'Belum Ada Jadwal Pemilahan',
      description:
          'Kamu sudah terdaftar sebagai nasabah bank sampah. Silakan buat jadwal pemilahan untuk mulai mengelola sampah.',
    );
  }
}
