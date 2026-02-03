import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_select_bank_controller.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_search_screen.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/features/home/widgets/bottom_nav_bar.dart';
import 'package:wanigo_nasabah/features/home/widgets/home_floating_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

class DepositSelectBankScreen extends StatelessWidget {
  const DepositSelectBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DepositSelectBankController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshWasteBanks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalHeader(
                  title: 'Form Pengajuan Setoran',
                  subtitle:
                      'Untuk Jadwal Setoran di ${DateFormatter.formatFullDate(DateTime.now())}',
                ),
                SizedBox(height: 24.h),
                const GlobalText(
                  text: 'Pilih Bank Sampah Tujuan',
                  variant: TextVariant.h6,
                  color: AppColors.gray600,
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  final wasteBankController = controller.wasteBankController;

                  if (wasteBankController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (wasteBankController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(wasteBankController.errorMessage.value),
                      ),
                    );
                  }

                  if (wasteBankController.wasteBankList.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: GlobalEmptyState(
                        iconPath: 'assets/icons/waste_bank_icon.svg',
                        title: 'Tidak Terdaftar di Bank Sampah Manapun',
                        description:
                            'Saat ini, kamu belum terdaftar sebagai nasabah di bank sampah manapun. Yuk, daftarkan dirimu di bank sampah terdekat untuk mulai menabung dan mengelola sampah dengan mudah!',
                        buttonText: 'Temukan Bank Sampah Terdekat',
                        onButtonPressed: () {
                          Get.to(() => const WasteBankSearchScreen());
                        },
                      ),
                    );
                  }

                  return Column(
                    children: wasteBankController.wasteBankList
                        .map((wasteBank) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: WasteBankCard(
                                wasteBank: wasteBank,
                                onTap: () =>
                                    controller.selectWasteBank(wasteBank),
                              ),
                            ))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: HomeFloatingActionButton(
        onPressed: () => Get.find<HomeController>().onBottomNavTapped(2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
