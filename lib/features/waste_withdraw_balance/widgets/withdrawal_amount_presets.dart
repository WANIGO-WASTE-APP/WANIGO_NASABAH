import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_balance_form_controller.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WithdrawalAmountPresets extends StatelessWidget {
  const WithdrawalAmountPresets({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WasteWithdrawBalanceFormController>();
    final presets = [25000, 50000, 75000, 100000, 150000, 200000];

    return Obx(() {
      final currentAmount = controller.amountText.value;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 12.h,
          mainAxisExtent: 48.h,
        ),
        itemCount: presets.length,
        itemBuilder: (context, index) {
          final amount = presets[index];
          final formattedAmount =
              'Rp${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
          final isActive = currentAmount == amount.toString();

          return GestureDetector(
            onTap: () => controller.setAmount(amount),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.blue800 : const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: GlobalText(
                text: formattedAmount,
                variant: TextVariant.mediumBold,
                color: isActive ? Colors.white : AppColors.gray500,
              ),
            ),
          );
        },
      );
    });
  }
}
