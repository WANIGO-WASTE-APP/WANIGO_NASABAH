import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(Routes.withdrawBalanceForm),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0026FF),
                Color(0xFF0038FF),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
            border: Border.all(
              color: Colors.white,
              width: 3.w,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/icons/waves_balance_card_icon.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/icons/wanigo_logo_bottom_icon.svg',
                  width: 90.w,
                  height: 90.h,
                ),
              ),
              Positioned(
                top: 10,
                right: 25,
                child: SvgPicture.asset(
                  'assets/icons/double_circle_icon.svg',
                  width: 28.w,
                  height: 28.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                      text: 'Nasabah',
                      variant: TextVariant.mediumSemiBold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    GlobalText(
                      text: 'Belum Menjadi Nasabah',
                      variant: TextVariant.largeExtraBold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12.h),
                    GlobalText(
                      text: 'Total Saldo Tabungan',
                      variant: TextVariant.mediumSemiBold,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    GlobalText(
                      text: 'Rp0',
                      variant: TextVariant.h3,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
