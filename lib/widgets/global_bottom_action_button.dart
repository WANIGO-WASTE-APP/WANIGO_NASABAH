import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalBottomActionButton extends StatelessWidget {
  final String? text;
  final String buttonText;
  final bool isLoading;
  final VoidCallback onPressed;

  const GlobalBottomActionButton({
    Key? key,
    this.text,
    required this.buttonText,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFCACACA),
            width: 0.8.r,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (text != null) ...[
                GlobalText(
                  text: text!,
                  variant: TextVariant.smallBold,
                  color: AppColors.gray600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
              ],
              GlobalButton(
                text: buttonText,
                variant: ButtonVariant.large,
                isLoading: isLoading,
                onPressed: isLoading ? () {} : onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
