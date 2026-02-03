import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class CashFlowCard extends StatelessWidget {
  const CashFlowCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            context,
            title: 'Pendapatan',
            amount: 'Rp0',
            iconPath: 'assets/icons/arrow_up_blue_icon.svg',
            iconBackgroundColor: AppColors.blue100,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildCard(
            context,
            title: 'Pengeluaran',
            amount: 'Rp0',
            iconPath: 'assets/icons/arrow_down_red_icon.svg',
            iconBackgroundColor: AppColors.red100,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String amount,
    required String iconPath,
    required Color iconBackgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.21.r),
        border: Border.all(color: Color(0xFFCACACA), width: 0.9.w),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.all(6.r),
            child: SvgPicture.asset(
              iconPath,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                  text: title,
                  variant: TextVariant.smallSemiBold,
                  color: AppColors.gray600,
                ),
                SizedBox(height: 4.h),
                GlobalText(
                  text: amount,
                  variant: TextVariant.mediumBold,
                  color: AppColors.gray900,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
