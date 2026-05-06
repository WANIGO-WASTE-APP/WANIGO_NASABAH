import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_nasabah/features/education/views/module.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class EducationModuleCard extends StatelessWidget {
  final String title;
  final int contentCount;
  final int duration;
  final bool isCompleted;
  final int progress;
  final IconData iconData;
  final Color placeholderColor;

  const EducationModuleCard({
    Key? key,
    required this.title,
    required this.isCompleted,
    this.contentCount = 10,
    this.duration = 100,
    this.progress = 0,
    this.iconData = Icons.recycling,
    this.placeholderColor = const Color(0xFF1565C0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetailScreen(title: title),
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
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Thumbnail placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: placeholderColor.withOpacity(0.12),
                  child: Icon(
                    iconData,
                    color: placeholderColor,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Module info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                      text: title,
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
                        GlobalText(
                          text: '$contentCount konten',
                          variant: TextVariant.smallMedium,
                          color: AppColors.gray700,
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/icons/clock_icon.svg',
                          width: 13.25.w,
                          height: 13.25.h,
                        ),
                        const SizedBox(width: 4),
                        GlobalText(
                          text: '$duration jam',
                          variant: TextVariant.smallMedium,
                          color: AppColors.gray700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Status indicator
              if (isCompleted)
                Column(
                  mainAxisSize: MainAxisSize.min,
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
              else
                SizedBox(
                  width: 49.29.w,
                  height: 49.29.h,
                  child: Stack(
                    alignment: Alignment.center,
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
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.blue800,
                            ),
                          ),
                        ),
                      ),
                      GlobalText(
                        text: '$progress%',
                        variant: TextVariant.smallMedium,
                        color: AppColors.gray700,
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
