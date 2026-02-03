import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/controllers/waste_withdraw_balance_controller.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/balance_card.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/cash_flow_card.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/withdraw_guidelines_section.dart';
import 'package:wanigo_nasabah/features/waste_withdraw_balance/widgets/cash_flow_history_section.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:flutter_svg/flutter_svg.dart';

class WasteWithdrawBalanceSelectScreen extends StatelessWidget {
  const WasteWithdrawBalanceSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteWithdrawBalanceController());

    return Scaffold(
      backgroundColor: AppColors.blue100,
      appBar: GlobalAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.9,
                initialPage: 1000,
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: BalanceCard(),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  left: -20,
                  right: -20,
                  child: AspectRatio(
                    aspectRatio: 393 / 195,
                    child: SvgPicture.asset(
                      'assets/images/plants_image2.svg',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.r),
                      child: CashFlowCard(),
                    ),
                    SizedBox(height: 48.h),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: SingleChildScrollView(
                          child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WithdrawGuidelinesSection(),
                                  if (controller.subTabIndex.value == 1)
                                    CashFlowHistorySection(),
                                  SizedBox(height: 24.h),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
