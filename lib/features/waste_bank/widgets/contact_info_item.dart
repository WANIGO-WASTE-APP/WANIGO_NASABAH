import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class ContactInfoItem extends StatelessWidget {
  final String iconPath;
  final String text;

  const ContactInfoItem(
      {super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 8),
        GlobalText(
          text: text,
          variant: TextVariant.mediumMedium,
          color: AppColors.gray600,
        ),
      ],
    );
  }
}
