import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_balance_form_controller.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/withdrawal_method_dropdown.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/withdrawal_amount_input.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/withdrawal_amount_presets.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class WasteWithdrawBalanceFormScreen extends StatelessWidget {
  const WasteWithdrawBalanceFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteWithdrawBalanceFormController());

    return Scaffold(
      appBar: GlobalAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalHeader(
                title: 'Penarikan Saldo',
                subtitle: 'Silakan pilih rekening and metode penarikan',
              ),
              SizedBox(height: 24.h),
              GlobalText(
                text: 'Pilih Rekening Bank Sampah',
                variant: TextVariant.mediumRegular,
                color: AppColors.gray900,
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0XFFCACACA)),
                  boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            text: 'Bank Sampah Kawan Surabaya',
                            variant: TextVariant.smallSemiBold,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4.h),
                          GlobalText(
                            text: 'Total Saldo: Rp100.000',
                            variant: TextVariant.smallMedium,
                            color: AppColors.gray600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/arrow_circle_right.svg',
                      width: 32.r,
                      height: 32.r,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              GlobalText(
                text: 'Metode Penarikan Saldo',
                variant: TextVariant.mediumRegular,
                color: AppColors.gray900,
              ),
              SizedBox(height: 16.h),
              Obx(() => WithdrawalMethodDropdown(
                    items: controller.methods,
                    value: controller.selectedMethod.value.isEmpty
                        ? null
                        : controller.selectedMethod.value,
                    onChanged: controller.selectMethod,
                  )),
              SizedBox(height: 24.h),
              GlobalText(
                text: 'Nominal Penarikan Saldo Tabungan',
                variant: TextVariant.mediumRegular,
                color: AppColors.gray900,
              ),
              SizedBox(height: 12.h),
              const WithdrawalAmountInput(),
              SizedBox(height: 24.h),
              GlobalText(
                text: 'Pilih Nominal Penarikan',
                variant: TextVariant.mediumSemiBold,
                color: Colors.black,
              ),
              SizedBox(height: 16.h),
              const WithdrawalAmountPresets(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (!controller.isFormValid) return const SizedBox.shrink();
        return GlobalBottomActionButton(
          buttonText: 'Lanjutkan',
          onPressed: () {},
        );
      }),
    );
  }
}
