import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalSuccessState extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String buttonText;
  final String? secondaryButtonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final double? iconSize;

  const GlobalSuccessState({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.buttonText,
    this.secondaryButtonText,
    this.onButtonPressed,
    this.onSecondaryButtonPressed,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bottom Illustration
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            'assets/images/plants_image.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        // Main Content
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: (iconSize ?? 95).w,
                    height: (iconSize ?? 95).h,
                  ),
                  const SizedBox(height: 16),
                  GlobalText(
                    text: title,
                    variant: TextVariant.h3,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  GlobalText(
                    text: description,
                    variant: TextVariant.mediumMedium,
                    color: AppColors.gray600,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GlobalButton(
                    text: buttonText,
                    onPressed: onButtonPressed,
                    variant: ButtonVariant.medium,
                  ),
                  if (secondaryButtonText != null &&
                      onSecondaryButtonPressed != null) ...[
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: onSecondaryButtonPressed,
                      child: GlobalText(
                        text: secondaryButtonText!,
                        variant: TextVariant.mediumBold,
                        color: AppColors.blue500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  // Extra space to prevent content from hitting the plants
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
