import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/utils/currency_input_formatter.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_balance_form_controller.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WithdrawalAmountInput extends StatelessWidget {
  const WithdrawalAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WasteWithdrawBalanceFormController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              GlobalText(
                text: 'Rp',
                variant: TextVariant.h2,
                color: AppColors.gray500,
              ),
              Expanded(
                child: TextField(
                  controller: controller.amountController,
                  style: TextStyle(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray500,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyInputFormatter(),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: controller.clearAmount,
          child: SvgPicture.asset(
            'assets/icons/close_circle_icon.svg',
            width: 32.w,
            height: 32.h,
          ),
        ),
      ],
    );
  }
}
