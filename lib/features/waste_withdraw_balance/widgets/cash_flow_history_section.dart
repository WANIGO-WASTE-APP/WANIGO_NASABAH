import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class CashFlowHistorySection extends StatelessWidget {
  const CashFlowHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.r, right: 20.r, bottom: 8.h),
          child: GlobalText(
            text: 'Arus Kas Terkini',
            variant: TextVariant.h5,
            color: AppColors.gray900,
          ),
        ),
        _buildCashFlowItem(
          title: 'Setoran KWN',
          date: '10 Apr 2025',
          amount: '+ Rp1.000.000,00',
          amountColor: AppColors.blue600,
        ),
        _buildCashFlowItem(
          title: 'Penarikan Saldo Tabungan',
          date: '10 Mei 2025',
          amount: '- Rp100.000',
          amountColor: AppColors.red600,
        ),
        _buildCashFlowItem(
          title: 'Penarikan Saldo Tabungan',
          date: '10 Mei 2025',
          amount: '- Rp100.000',
          amountColor: AppColors.red600,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildCashFlowItem({
    required String title,
    required String date,
    required String amount,
    required Color amountColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                      text: title,
                      variant: TextVariant.mediumBold,
                      color: AppColors.gray900,
                    ),
                    SizedBox(height: 4.h),
                    GlobalText(
                      text: 'Tercatat tanggal $date',
                      variant: TextVariant.smallRegular,
                      color: AppColors.gray600,
                    ),
                  ],
                ),
              ),
              GlobalText(
                text: amount,
                variant: TextVariant.mediumBold,
                color: amountColor,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFE5E7EB),
          ),
      ],
    );
  }
}
