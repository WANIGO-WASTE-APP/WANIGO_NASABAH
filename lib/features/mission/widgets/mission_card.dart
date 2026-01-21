import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: GlobalShadow.getShadow(ShadowVariant.xxLarge),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0026FF),
                    Color(0xFF0038FF),
                  ],
                ),
                boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlobalText(
                    text: 'Selesaikan Misi WANIGO!\nTransaksi Setoran 5 Kali',
                    variant: TextVariant.h4,
                    color: Colors.white,
                  ),
                  SizedBox(height: 28.h),
                  GlobalText(
                    text: 'Dapatkan 1000 WANIGO! Poin',
                    variant: TextVariant.smallSemiBold,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildMissionProgress(0.8),
                            SizedBox(height: 12.h),
                            GlobalText(
                              text: '4 dari 5 transaksi dikerjakan',
                              variant: TextVariant.xSmallSemiBold,
                              color: AppColors.gray600,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35.h,
                        width: 110.w,
                        child: GlobalButton(
                          onPressed: () {},
                          text: 'Kerjakan',
                          variant: ButtonVariant.small,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMissionProgress(double progress) {
  return SizedBox(
    height: 22.h,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.blue200,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.blue900, width: 1.w),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0026FF),
                    Color(0xFF0038FF),
                  ],
                ),
                border: Border.all(color: AppColors.blue900, width: 1.w),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Center(
            child: GlobalText(
              text: '${(progress * 100).round()}%',
              variant: TextVariant.smallMedium,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
