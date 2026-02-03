import 'package:flutter/material.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const GlobalHeader({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText(
          text: title,
          variant: TextVariant.h4,
          color: AppColors.gray600,
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 4),
          GlobalText(
            text: subtitle!,
            variant: TextVariant.smallMedium,
            color: AppColors.gray400,
          ),
        ],
      ],
    );
  }
}
