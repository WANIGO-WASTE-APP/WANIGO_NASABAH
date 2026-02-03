import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomeFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final bool isActive = homeController.currentIndex.value == 2;

      return Transform.translate(
        offset: Offset(0, 25.h),
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.translucent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: onPressed,
                backgroundColor:
                    isActive ? AppColors.blue800 : AppColors.gray900,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: Colors.white,
                    width: 3.r,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/images/setoran_icon.svg',
                  width: 29.r,
                  height: 29.r,
                ),
              ),
              SizedBox(height: 4.h),
              GlobalText(
                text: 'Penjualan',
                variant: TextVariant.xSmallMedium,
                color: isActive ? AppColors.blue600 : AppColors.gray900,
              ),
            ],
          ),
        ),
      );
    });
  }
}
