import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class GlobalBottomActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlobalBottomActionButton({
    Key? key,
    required this.text,
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
          child: GlobalButton(
            text: text,
            variant: ButtonVariant.large,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
