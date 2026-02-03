import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/features/deposit_history/widgets/status_badge.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/core/utils/currency_formatter.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_history_model.dart';

class DepositHistoryCard extends StatelessWidget {
  final WasteDepositHistoryModel history;

  const DepositHistoryCard({
    Key? key,
    required this.history,
  }) : super(key: key);

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormatter.formatFullDate(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFCACACA), width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GlobalText(
                      text: 'Kode Setoran Sampah',
                      variant: TextVariant.smallSemiBold,
                      color: AppColors.gray600,
                    ),
                    SizedBox(height: 6.h),
                    GlobalText(
                      text: history.kodeSetoranSampah,
                      variant: TextVariant.largeBold,
                      color: Colors.black,
                    ),
                  ],
                ),
                StatusBadge(status: history.statusSetoran),
              ],
            ),
            SizedBox(height: 4.h),
            Divider(color: Color(0xFFCACACA), thickness: 0.6.h),
            SizedBox(height: 4.h),
            GlobalText(
              text: history.bankSampah?.name ?? 'Bank Sampah',
              variant: TextVariant.h6,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                GlobalText(
                  text: CurrencyFormatter.format(history.totalSaldo),
                  variant: TextVariant.mediumBold,
                  color: AppColors.blue600,
                ),
                SizedBox(width: 4.w),
                GlobalText(
                  text:
                      '(${history.jumlahItem} item ≈ ${history.totalBeratFormat})',
                  variant: TextVariant.xSmallMedium,
                  color: AppColors.gray600,
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.r, vertical: 4.r),
                  decoration: BoxDecoration(
                    color: AppColors.blue100,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(color: AppColors.blue600, width: 0.6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/point_icon.svg',
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 4.w),
                      GlobalText(
                        text: '${history.totalPoin} POIN',
                        variant: TextVariant.smallBold,
                        color: AppColors.blue800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Divider(color: Color(0xFFCACACA), thickness: 0.6.h),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: GlobalText(
                    text:
                        'Terakhir pada tanggal ${_formatDate(history.tanggalSetoran)}',
                    variant: TextVariant.xSmallSemiBold,
                    color: AppColors.gray500,
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  height: 38.h,
                  width: 140.w,
                  child: GlobalButton(
                    text: 'Detail Setoran',
                    variant: ButtonVariant.small,
                    onPressed: () {
                      Get.toNamed(
                        Routes.setoranSampahDetail,
                        arguments: history,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
