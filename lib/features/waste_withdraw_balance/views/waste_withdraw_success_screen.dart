import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_success_controller.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_success_state.dart';

class WasteWithdrawSuccessScreen extends StatelessWidget {
  const WasteWithdrawSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteWithdrawSuccessController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        onBackPressed: controller.navigateHome,
      ),
      body: GlobalSuccessState(
        iconPath: 'assets/icons/form_success_icon.svg',
        iconSize: 162.r,
        title: 'Penarikan Saldo \n Berhasil Diajukan',
        description:
            'Pengajuan penarikan saldo Anda telah berhasil diajukan. Pantau status pengajuan Anda di halaman Riwayat Penarikan',
        buttonText: 'Lihat Riwayat Pengajuan',
        onButtonPressed: controller.navigateToStatus,
      ),
    );
  }
}
