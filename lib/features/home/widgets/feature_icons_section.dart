import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class FeatureIconsSection extends StatelessWidget {
  const FeatureIconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'label': 'Edukasi',
        'svg': 'assets/icons/edukasi_icon.svg',
      },
      {
        'label': 'Laporan',
        'svg': 'assets/icons/laporan_icon.svg',
      },
      {
        'label': 'Juara',
        'svg': 'assets/icons/juara_icon.svg',
      },
      {
        'label': 'Misi',
        'svg': 'assets/icons/misi_icon.svg',
      },
      {
        'label': 'Lainnya',
        'svg': 'assets/icons/lainnya_icon.svg',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: features.map((f) {
        return Column(
          children: [
            SvgPicture.asset(
              f['svg'] as String,
              width: 56.r,
              height: 56.r,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            GlobalText(
              text: f['label'] as String,
              variant: TextVariant.smallMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}
