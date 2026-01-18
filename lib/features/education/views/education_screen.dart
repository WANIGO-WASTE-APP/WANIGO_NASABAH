import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/education/widgets/education_module_card.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        enableShadow: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/education_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/edukasi_icon.svg',
                  width: 95.w,
                  height: 95.w,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const GlobalText(
                        text: 'Edukasi Sampah',
                        variant: TextVariant.h4,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      const GlobalText(
                        text:
                            'Pelajari cara mengolah sampah dengan mudah, dapatkan manfaat ekonomis, sekaligus bantu jaga bumi kita',
                        variant: TextVariant.xSmallSemiBold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Module list section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const GlobalText(
                  text: 'Daftar Modul Edukasi',
                  variant: TextVariant.mediumBold,
                  color: AppColors.gray600,
                ),
                Row(
                  children: [
                    const GlobalText(
                      text: '1/6',
                      variant: TextVariant.smallBold,
                      color: AppColors.gray700,
                    ),
                    const SizedBox(width: 4),
                    const GlobalText(
                      text: 'terselesaikan',
                      variant: TextVariant.xSmallSemiBold,
                      color: AppColors.gray700,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Module cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const EducationModuleCard(isCompleted: true),
                const EducationModuleCard(isCompleted: false, progress: 80),
                const EducationModuleCard(isCompleted: false, progress: 80),
                const EducationModuleCard(isCompleted: false, progress: 80),
                const EducationModuleCard(isCompleted: false, progress: 80),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
