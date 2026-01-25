import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class DetailInfoBadge extends StatelessWidget {
  final String iconPath;
  final String text;

  const DetailInfoBadge(
      {super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.gray100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath),
          const SizedBox(width: 8),
          Center(
            child: GlobalText(
              text: text,
              variant: TextVariant.xSmallMedium,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
