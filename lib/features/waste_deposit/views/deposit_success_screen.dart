import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_success_controller.dart';
import 'package:wanigo_nasabah/widgets/global_succes_state.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

class DepositSuccessScreen extends StatelessWidget {
  const DepositSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DepositSuccessController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        onBackPressed: controller.navigateHome,
      ),
      body: GlobalSuccessState(
        iconPath: 'assets/icons/form_success_icon.svg',
        iconSize: 162.r,
        title: 'Pengajuan Setoran\nSampah Terkirim! 🎉',
        description:
            'Formulir pengajuan setoran sampah kamu berhasil dibuat dan telah diajukan ke bank sampah tujuan. Proses verifikasi akan berlangsung maksimal 2x24 jam',
        buttonText: 'Lihat Status Pengajuan',
        onButtonPressed: controller.navigateToStatus,
        secondaryButtonText: 'Kembali',
        onSecondaryButtonPressed: controller.navigateHome,
      ),
    );
  }
}
