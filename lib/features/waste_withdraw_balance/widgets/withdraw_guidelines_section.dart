import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_balance_controller.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WithdrawGuidelinesSection extends StatelessWidget {
  const WithdrawGuidelinesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WasteWithdrawBalanceController>();

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            text: 'Penarikan Saldo Tabungan',
            variant: TextVariant.h5,
            color: AppColors.gray600,
          ),
          SizedBox(height: 16.h),
          _buildSubTabSelector(controller),
          Obx(() {
            if (controller.subTabIndex.value != 0)
              return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                GlobalText(
                  text: 'PERLU DIPERHATIKAN!',
                  variant: TextVariant.smallBold,
                  color: AppColors.gray500,
                ),
                SizedBox(height: 4.h),
                GlobalText(
                  text:
                      'Perhatikan hal-hal berikut sebelum melakukan penarikan saldo tabungan WANIGO:',
                  variant: TextVariant.smallRegular,
                  color: AppColors.gray600,
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalText(
                        text:
                            '1. Penarikan saldo pertama kali (untuk nasabah baru) dapat dilakukan setelah 6 bulan dari setoran pertama.',
                        variant: TextVariant.smallRegular,
                        color: AppColors.gray600,
                      ),
                      SizedBox(height: 4.h),
                      GlobalText(
                        text:
                            '2. Penarikan saldo berikutnya dapat dilakukan setiap bulan dengan sisa saldo minimal 25 ribu',
                        variant: TextVariant.smallRegular,
                        color: AppColors.gray600,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubTabSelector(WasteWithdrawBalanceController controller) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildSubTabItem(
              title: 'Tarik Saldo',
              isActive: controller.subTabIndex.value == 0,
              onTap: () => controller.setSubTab(0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSubTabItem(
              title: 'Riwayat Penarikan',
              isActive: controller.subTabIndex.value == 1,
              onTap: () => controller.setSubTab(1),
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
