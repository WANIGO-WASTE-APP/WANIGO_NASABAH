import 'package:flutter/material.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class ScheduleSectionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const ScheduleSectionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          decoration: const BoxDecoration(color: AppColors.blue600),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalText(
              text: title,
              variant: TextVariant.smallSemiBold,
              color: AppColors.gray300,
            ),
            const SizedBox(height: 8),
            GlobalText(
              text: subtitle,
              variant: TextVariant.mediumSemiBold,
              color: AppColors.gray700,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 16, color: AppColors.blue500),
                const SizedBox(width: 3),
                GlobalText(
                  text: time,
                  variant: TextVariant.smallMedium,
                  color: AppColors.blue500,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
