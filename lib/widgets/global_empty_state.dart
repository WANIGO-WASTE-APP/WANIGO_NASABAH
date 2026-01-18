import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalEmptyState extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const GlobalEmptyState({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 95.w,
                  height: 95.h,
                ),
                const SizedBox(height: 12),
                GlobalText(
                  text: title,
                  variant: TextVariant.h5,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                GlobalText(
                  text: description,
                  variant: TextVariant.smallSemiBold,
                  color: AppColors.gray600,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GlobalButton(
            text: buttonText,
            onPressed: onButtonPressed,
            variant: ButtonVariant.medium,
          ),
        ],
      ),
    );
  }
}
