import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_screen.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';

class ScheduleEmptyUnregisteredBank extends StatelessWidget {
  const ScheduleEmptyUnregisteredBank({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      iconPath: 'assets/icons/form_submission_icon.svg',
      title: 'Daftar Jadi Nasabah Bank\nUntuk Mulai Jadwal Pemilahan',
      description:
          'Pastikan kamu menjadi nasabah bank sampah sebelum mengatur jadwal pemilahan. Daftar sekarang untuk memulai pengelolaan sampah ',
      buttonText: 'Temukan Bank Sampah Terdekat',
      onButtonPressed: () {
        Get.to(() => const WasteBankScreen());
      },
    );
  }
}
