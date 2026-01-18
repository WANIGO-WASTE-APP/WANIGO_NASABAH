import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/setoran_sampah_model.dart';

class SetoranSampahCard extends StatelessWidget {
  final SetoranSampahModel setoran;

  const SetoranSampahCard({
    super.key,
    required this.setoran,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353.22.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFCACACA), width: 1.w),
        color: Colors.white,
        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
      ),
      child: Row(
        children: [
          _buildIconWithBg(context),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText(
                    text: setoran.title,
                    variant: TextVariant.mediumBold,
                    color: Colors.black),
                SizedBox(height: 4.h),
                GlobalText(
                    text: setoran.description,
                    variant: TextVariant.smallMedium,
                    color: Colors.black),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/icons/arrow_right_icon.svg',
            width: 50.r,
            height: 50.r,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithBg(BuildContext context) {
    return Container(
      width: 60.r,
      height: 60.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/box_icon.svg',
          width: 60.r,
          height: 60.r,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
