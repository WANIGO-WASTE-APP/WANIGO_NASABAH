import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';

class ScheduleEmptyTimetable extends StatelessWidget {
  const ScheduleEmptyTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      iconPath: 'assets/icons/form_submission_icon.svg',
      title: 'Daftar Jadi Nasabah Bank\nUntuk Mulai Jadwal Pemilahan',
      description:
          'Pastikan kamu menjadi nasabah bank sampah sebelum mengatur jadwal pemilahan. Daftar sekarang untuk memulai pengelolaan sampah ',
      buttonText: 'Temukan Bank Sampah Terdekat',
      onButtonPressed: () {},
    );
  }
}
