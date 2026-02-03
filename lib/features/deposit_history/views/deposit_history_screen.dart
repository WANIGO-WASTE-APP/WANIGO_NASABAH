import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_controller.dart';
import 'package:wanigo_nasabah/features/deposit_history/widgets/deposit_history_card.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_nasabah/features/home/widgets/bottom_nav_bar.dart';
import 'package:wanigo_nasabah/features/home/widgets/home_floating_action_button.dart';

class DepositHistoryScreen extends GetView<DepositHistoryController> {
  const DepositHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: GlobalHeader(title: 'Setoran Sampah'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.r),
              child: GlobalTabMenu(
                tabs: const ['Riwayat', 'Berlangsung'],
                initialIndex: controller.selectedTabIndex.value,
                onTabSelected: (index) => controller.changeTab(index),
              ),
            ),
            if (controller.selectedTabIndex.value == 0) ...[
              _buildSubTabSelector(),
              SizedBox(height: 16.h),
            ],
            Expanded(
              child: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (controller.memberBankList.isEmpty ||
                          controller.historyItems.isEmpty)
                      ? Center(
                          child: GlobalEmptyState(
                            iconPath: 'assets/icons/bag_icon.svg',
                            iconSize: 170,
                            title: 'Data Setoran\nTidak Ditemukan',
                            description:
                                'Belum ada data setoran sampah yang tercatat. Pastikan kamu telah mengajukan setoran sampah atau coba periksa kembali jadwal setoran yang telah dibuat.',
                            buttonText: 'Buat Setoran Baru',
                            onButtonPressed: () {
                              homeController.onBottomNavTapped(2);
                            },
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            if (controller.selectedTabIndex.value == 1) {
                              await controller.fetchOngoingSetoran();
                            } else {
                              await controller.fetchMemberBanks();
                            }
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 24.r),
                            child: Column(
                              children: controller.historyItems.map((history) {
                                return DepositHistoryCard(history: history);
                              }).toList(),
                            ),
                          ),
                        ),
            ),
          ],
        );
      }),
      floatingActionButton: HomeFloatingActionButton(
        onPressed: () => homeController.onBottomNavTapped(2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildSubTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSubTabItem(
              title: 'Selesai',
              isActive: controller.subTabIndex.value == 0,
              onTap: () {
                controller.subTabIndex.value = 0;
                controller.fetchMemberBanks();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSubTabItem(
              title: 'Dibatalkan',
              isActive: controller.subTabIndex.value == 1,
              onTap: () {
                controller.subTabIndex.value = 1;
                controller.fetchMemberBanks();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue800 : const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: GlobalText(
          text: title,
          variant: TextVariant.smallBold,
          color: isActive ? Colors.white : AppColors.gray500,
        ),
      ),
    );
  }
}
