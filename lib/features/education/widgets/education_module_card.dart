import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/features/education/views/module.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EducationModuleCard extends StatelessWidget {
  final bool isCompleted;
  final int progress;

  const EducationModuleCard({
    Key? key,
    required this.isCompleted,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ModuleDetailScreen(
              title: 'Judul Modul Edukasi Sampah',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC4C4C4), width: 0.6),
          boxShadow: GlobalShadow.getShadow(ShadowVariant.large),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkerboard icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFC4C4C4), width: 0.6),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(9, (index) {
                    return Container(
                      color: (index % 2 == 0) ? Colors.black : Colors.white,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 16),
              // Module info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GlobalText(
                      text: 'Judul Modul Edukasi Sampah',
                      variant: TextVariant.mediumBold,
                      color: AppColors.gray700,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/book_icon.svg',
                          width: 13.25.w,
                          height: 13.25.h,
                        ),
                        const SizedBox(width: 4),
                        const GlobalText(
                            text: '10 konten',
                            variant: TextVariant.smallMedium,
                            color: AppColors.gray700),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/clock_icon.svg',
                          width: 13.25.w,
                          height: 13.25.h,
                        ),
                        const SizedBox(width: 4),
                        const GlobalText(
                            text: '100 jam',
                            variant: TextVariant.smallMedium,
                            color: AppColors.gray700),
                      ],
                    ),
                  ],
                ),
              ),
              // Status indicator
              isCompleted
                  ? Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/completed_icon.svg',
                          width: 49.29.w,
                          height: 49.29.h,
                        ),
                        const SizedBox(height: 4),
                        const GlobalText(
                          text: 'selesai',
                          variant: TextVariant.smallMedium,
                          color: AppColors.green600,
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 49.29.w,
                      height: 49.29.h,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 49.29.w,
                            height: 49.29.h,
                            child: Transform.scale(
                              scaleX: -1,
                              child: CircularProgressIndicator(
                                value: progress / 100,
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                                backgroundColor: AppColors.blue300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.blue800),
                              ),
                            ),
                          ),
                          Center(
                            child: GlobalText(
                              text: '$progress%',
                              variant: TextVariant.smallMedium,
                              color: AppColors.gray700,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
