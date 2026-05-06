import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/select_schedule_type_screen.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';

class ScheduleEmptyTimetable extends StatelessWidget {
  const ScheduleEmptyTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      iconPath: 'assets/icons/add_calendar_icon.svg',
      title: 'Jadwal Belum Dibuat',
      description:
          'Buat jadwal pemilahan atau setoran sampah untuk memulai proses pengelolaan sampah yang lebih teratur dan efisien',
      buttonText: 'Buat Jadwal',
      onButtonPressed: () {
        Get.to(() => const SelectScheduleTypeScreen());
      },
    );
  }
}
