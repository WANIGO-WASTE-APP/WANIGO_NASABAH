import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_success_state.dart';

class ScheduleSuccessScreen extends StatelessWidget {
  final String? title;
  final String? description;

  const ScheduleSuccessScreen({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        enableShadow: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: GlobalSuccessState(
        iconPath: 'assets/icons/form_success_icon.svg',
        iconSize: 120,
        title: title ?? 'Yeay! Jadwal Pemilahan Berhasil Dibuat 🎉',
        description: description ??
            'Jadwal pemilahan sampah Anda telah berhasil diset untuk dimulai. Terima kasih telah berpartisipasi dalam menjaga kebersihan lingkungan!',
        buttonText: 'Kembali',
        onButtonPressed: () {
          Get.offAllNamed('/home');
        },
      ),
    );
  }
}
